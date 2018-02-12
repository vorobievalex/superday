import Foundation

protocol Interactor
{
    associatedtype ReturnType
    func execute() -> ReturnType
}

class InteractorFactory
{
    var coreDataPersistency: CoreDataPersistency!
    var timeService: TimeService!
    var timeSlotService: TimeSlotService!
    var appLifecycleService: AppLifecycleService!
    var motionService: MotionService!
    
    static var shared: InteractorFactory = InteractorFactory()
    
    private init() {}
    
    func setup(coreDataPersistency: CoreDataPersistency, timeService: TimeService, timeSlotService: TimeSlotService, appLifecycleService: AppLifecycleService, motionService: MotionService)
    {
        self.coreDataPersistency = coreDataPersistency
        self.timeService = timeService
        self.timeSlotService = timeSlotService
        self.appLifecycleService = appLifecycleService
        self.motionService = motionService
    }
    
    // INTERACTOR CREATORS
    
    func createGetTimeSlotsForDateInteractor(date: Date) -> GetTimeSlotsForDate
    {
        return GetTimeSlotsForDate(persistency: coreDataPersistency, timeService: timeService, timeSlotService: timeSlotService, appLifecycleService: appLifecycleService, date: date)
    }
    
    func createImportMotionEventsInteractor() -> ImportMotionEvents
    {
        return ImportMotionEvents(persistency: coreDataPersistency, timeService: timeService, motionService: motionService)
    }
}
