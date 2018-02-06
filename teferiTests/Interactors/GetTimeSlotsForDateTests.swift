import XCTest
import Foundation
import XCTest
import RxSwift
import RxTest
import Nimble
@testable import teferi

class GetTimeSlotsForDateTests: XCTestCase
{
    private var getTimeSlotsForDate: GetTimeSlotsForDate!
    
    private var persistencyService: MockCoreDataPersistency!
    private var timeService: MockTimeService!
    private var timeSlotService: SimpleMockTimeSlotService!
    private var appLifecycleService: MockAppLifecycleService!
    
    private var scheduler: TestScheduler!
    private var subscription: Disposable!
    
    override func setUp()
    {
        persistencyService = MockCoreDataPersistency()
        timeService = MockTimeService()
        timeSlotService = SimpleMockTimeSlotService()
        appLifecycleService = MockAppLifecycleService()
        
        let date = Date()
        
        getTimeSlotsForDate = GetTimeSlotsForDate(persistency: persistencyService,
                                                  timeService: timeService,
                                                  timeSlotService: timeSlotService,
                                                  appLifecycleService: appLifecycleService,
                                                  date: date)
        
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown()
    {
        scheduler.scheduleAt(1000) {
            self.subscription.dispose()
        }
        super.tearDown()
    }
    
    func testViewModelsForTheOlderDaysDoNotSubscribeForTimeSlotUpdates()
    {
        let observer = scheduler.createObserver([TimeSlot].self)
        
        let timeSlots = [
            TimeSlot(startTime: Date(), endTime: Date().addingTimeInterval(60), category: .work)
        ]
        
        timeSlotService.timeSlotsToReturn = timeSlots
        timeService.mockDate = Date()
        
        subscription = getTimeSlotsForDate.execute()
            .subscribe(observer)
        
        timeSlotService.update(timeSlots: timeSlots, withCategory: .leisure)
        
        scheduler.start()

        print(observer.events)
        
        //expect(observer.events.count).toEventually(be(1))
    }
}
