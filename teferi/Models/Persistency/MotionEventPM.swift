import Foundation
import CoreData

struct MotionEventPM
{
    let startTime: Date
    let motionType: MotionEventType
}

extension MotionEventPM: PersistencyModel
{
    static var entityName: String = "MotionEvent"
    
    init(managedObject: NSManagedObject) throws
    {
        guard let startTime = managedObject.value(forKey: "startTime") as? Date,
            let motionTypeString = managedObject.value(forKey: "motionType") as? String,
            let motionType = MotionEventType(rawValue: motionTypeString) else {
                throw PersistencyError.couldntParse
        }
        
        self.startTime = startTime
        self.motionType = motionType
    }
    
    func encode(using moc: NSManagedObjectContext) -> NSManagedObject
    {
        guard let entity = NSEntityDescription.entity(forEntityName: type(of: self).entityName, in: moc) else { fatalError("Can't create entity") }
        
        let managedObject = NSManagedObject(entity: entity, insertInto: moc)
        managedObject.setValue(startTime, forKey: "startTime")
        managedObject.setValue(motionType.rawValue, forKey: "motionType")
        
        return managedObject
    }
}


extension MotionEventPM
{
    static func all(from startDate: Date, to endDate: Date) -> CoreDataResource<[MotionEventPM]>
    {
        let predicate = Predicate(parameter: "startTime", rangesFromDate: startDate as NSDate, toDate: endDate as NSDate)
        let sortDescriptor = NSSortDescriptor(key: "startTime", ascending: true)
        return CoreDataResource<[MotionEventPM]>.many(predicate: predicate, sortDescriptor: sortDescriptor)
    }
    
    static func last() -> CoreDataResource<MotionEventPM>
    {
        let sortDescriptor = NSSortDescriptor(key: "startTime", ascending: false)
        return CoreDataResource<[MotionEventPM]>.single(sortDescriptor: sortDescriptor)
    }
}

