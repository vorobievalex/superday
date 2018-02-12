import Foundation
import RxSwift

class ImportMotionEvents: Interactor
{
    let persistency: CoreDataPersistency
    let timeService: TimeService
    let motionService: MotionService
    
    let disposeBag = DisposeBag()
    
    init(persistency: CoreDataPersistency, timeService: TimeService, motionService: MotionService)
    {
        self.persistency = persistency
        self.timeService = timeService
        self.motionService = motionService
    }
    
    func execute() -> Observable<[MotionEvent]>
    {
        return getLastMotionDate()
            .flatMapLatest(getMotionEvents)
            .flatMapLatest(saveMotionEvents)
    }
    
    private func getLastMotionDate() -> Observable<Date>
    {
        return persistency.fetch(MotionEventPM.last())
            .map({ $0.startTime })
            .catchError({ [unowned self] (error) -> Observable<Date> in
                if let persistencyError = error as? PersistencyError, persistencyError == .noResults
                {
                    return Observable.of(self.timeService.now.add(days: -7))
                } else {
                    throw error
                }
            })
    }
    
    private func getMotionEvents(_ since: Date) -> Observable<[MotionEvent]>
    {
        return motionService
            .getActivities(since: since, until: timeService.now)
            .map({ (events) in
                return events.filter({ $0.start > since })
            })
    }
    
    private func saveMotionEvents(_ motionEvents: [MotionEvent]) -> Observable<[MotionEvent]>
    {
        return Observable.from(motionEvents)
            .flatMap(saveMotionEvent)
            .toArray()
    }
    
    private func saveMotionEvent(motionEvent: MotionEvent) -> Observable<MotionEvent>
    {
        let eventPM = MotionEventPM(startTime: motionEvent.start, motionType: motionEvent.type)
        persistency.create(eventPM).subscribe().disposed(by: disposeBag)
        return Observable.of(motionEvent)
    }
}
