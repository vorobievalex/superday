import Foundation

struct SlotTimelineItem
{
    let timeSlots : [TimeSlot]
    let shouldDisplayCategoryName : Bool
    let isLastInPastDay : Bool
    let isRunning: Bool
    
    var startTime: Date
    {
        return timeSlots.first!.startTime
    }
    
    var endTime: Date?
    {
        return timeSlots.last!.endTime
    }
    
    var duration: TimeInterval
    {
        guard let endTime = endTime else { return 0 }
        return endTime.timeIntervalSince(startTime)
    }
    
    var category: Category
    {
        return timeSlots.first!.category
    }
    
    var containsMultiple: Bool
    {
        return timeSlots.count > 1
    }
    
    init (timeSlots: [TimeSlot], shouldDisplayCategoryName: Bool = true, isLastInPastDay: Bool = false, isRunning: Bool = false)
    {
        assert(!timeSlots.isEmpty, "Can't create a SlotTimelineItem without slots")
        
        self.timeSlots = timeSlots
        self.shouldDisplayCategoryName = shouldDisplayCategoryName
        self.isLastInPastDay = isLastInPastDay
        self.isRunning = isRunning
    }
}

extension SlotTimelineItem
{
    func withLastTimeSlotFlag(isCurrentDay: Bool) -> SlotTimelineItem
    {
        return SlotTimelineItem(
            timeSlots: self.timeSlots,
            shouldDisplayCategoryName: self.shouldDisplayCategoryName,
            isLastInPastDay: !isCurrentDay,
            isRunning: isCurrentDay
        )
    }
}
