import Foundation
import RxSwift

class GetTimeSlotsForDate: Interactor
{
    let persistency: CoreDataPersistency
    
    let date: Date
    
    init(persistency: CoreDataPersistency, date: Date)
    {
        self.persistency = persistency
        self.date = date
    }
    
    func execute() -> Observable<[TimeSlot]>
    {
        // This is temporal, next we'll merge this with locations and motion events
        return persistency.fetch(TimeSlotPM.all(forDate: date))
            .map { timeslots in
                return timeslots.map {
                    TimeSlot(withStartTime: $0.startTime, category: $0.category)
                }
            }
    }
}
