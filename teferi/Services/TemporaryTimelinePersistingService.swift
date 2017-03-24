import Foundation
import CoreLocation

class TemporaryTimelinePersistingService
{
    private typealias SmartGuessUpdate = (smartGuess: SmartGuess, time: Date)
    
    private let settingsService : SettingsService
    private let timeSlotService : TimeSlotService
    private let smartGuessService : SmartGuessService
    private let trackEventService : TrackEventService
    
    init(settingsService: SettingsService,
         timeSlotService: TimeSlotService,
         smartGuessService: SmartGuessService,
         trackEventService: TrackEventService)
    {
        self.settingsService = settingsService
        self.timeSlotService = timeSlotService
        self.smartGuessService = smartGuessService
        self.trackEventService = trackEventService
    }
    
    func execute(data: [TemporaryTimeSlot])
    {
        if data.isEmpty { return }
        
        var lastLocation : CLLocation? = nil
        var smartGuessesToUpdate = [SmartGuessUpdate]()
        
        for temporaryTimeSlot in data
        {
            let addedTimeSlot : TimeSlot?
            if let smartGuess = temporaryTimeSlot.smartGuess
            {
                addedTimeSlot = self.timeSlotService.addTimeSlot(withStartTime: temporaryTimeSlot.start,
                                                                 smartGuess: smartGuess,
                                                                 location: temporaryTimeSlot.location?.toCLLocation())
                
                smartGuessesToUpdate.append((smartGuess, temporaryTimeSlot.start))
            }
            else
            {
                addedTimeSlot = self.timeSlotService.addTimeSlot(withStartTime: temporaryTimeSlot.start,
                                                                 category: temporaryTimeSlot.category,
                                                                 categoryWasSetByUser: false,
                                                                 location: temporaryTimeSlot.location?.toCLLocation())
            }
            
            lastLocation = addedTimeSlot?.location ?? lastLocation
        }
        
        self.updateIfNeeded(lastLocation: lastLocation)
        smartGuessesToUpdate.forEach { self.smartGuessService.markAsUsed($0.smartGuess, atTime: $0.time) }
        
        self.trackEventService.clearAllData()
    }
    
    private func updateIfNeeded(lastLocation: CLLocation?)
    {
        guard let lastLocation = lastLocation else { return }
        
        self.settingsService.setLastLocation(lastLocation)
    }
}
