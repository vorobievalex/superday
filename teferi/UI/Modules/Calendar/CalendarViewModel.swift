import Foundation
import RxSwift

///ViewModel for the CalendardViewModel.
class CalendarViewModel
{
    // MARK: Fields
    private let timeService : TimeService
    private let timeSlotService : TimeSlotService
    private var selectedDateService : SelectedDateService
    private let currentVisibleCalendarDateVariable : Variable<Date>
    
    // MARK: Initializers
    init(timeService: TimeService,
         settingsService: SettingsService,
         timeSlotService: TimeSlotService,
         selectedDateService: SelectedDateService)
    {
        self.timeService = timeService
        self.timeSlotService = timeSlotService
        self.selectedDateService = selectedDateService
        
        minValidDate = settingsService.installDate ?? timeService.now
        
        currentVisibleCalendarDateVariable = Variable(timeService.now)
        dateObservable = selectedDateService.currentlySelectedDateObservable
        currentVisibleCalendarDateObservable = currentVisibleCalendarDateVariable.asObservable()
    }
    
    // MARK: Properties
    let minValidDate : Date
    var maxValidDate : Date { return self.timeService.now }
    
    let dateObservable : Observable<Date>
    let currentVisibleCalendarDateObservable : Observable<Date>
    
    var selectedDate : Date
    {
        get { return self.selectedDateService.currentlySelectedDate }
        set(value) { self.selectedDateService.currentlySelectedDate = value }
    }
    
    var currentVisibleCalendarDate : Date
    {
        get { return self.currentVisibleCalendarDateVariable.value }
        set(value) { self.currentVisibleCalendarDateVariable.value = value }
    }
    
    // MARK: Methods
    func canScroll(toDate date: Date) -> Bool
    {
        let cellDate = date.ignoreTimeComponents()
        let minDate = minValidDate.ignoreTimeComponents()
        let maxDate = maxValidDate.ignoreTimeComponents()
        
        let dateIsWithinInterval = minDate...maxDate ~= cellDate
        return dateIsWithinInterval
    }
    
    func getActivities(forDate date: Date) -> [Activity]?
    {
        guard canScroll(toDate: date) else { return nil }
        
        let result = timeSlotService
                .getTimeSlots(forDay: date)
                .groupBy(category)
                .map(toActivity)
                .sorted(by: category)
        
        return result
    }
    
    private func categoryIsSet(for timeSlot: TimeSlot) -> Bool
    {
        return timeSlot.category != .unknown
    }
    
    private func category(of timeSlot: TimeSlot) -> Category
    {
        return timeSlot.category
    }
    
    private func toActivity(_ timeSlots: [TimeSlot]) -> Activity
    {
        let totalTime =
            timeSlots
                .map(timeSlotService.calculateDuration)
                .reduce(0, +)
        
        return Activity(category: timeSlots.first!.category, duration: totalTime)
    }
    
    private func category(_ element1: Activity, _ element2: Activity) -> Bool
    {
        let allCategories = Category.all
        let index1 = allCategories.index(of: element1.category)!
        let index2 = allCategories.index(of: element2.category)!
        
        return index1 > index2
    }
}
