import Foundation

protocol Interactor
{
    associatedtype ReturnType
    func execute() -> ReturnType
}

class InteractorFactory
{
    var coreDataPersistency: CoreDataPersistency!
    static var shared: InteractorFactory = InteractorFactory()
    
    private init() {}
    
    func setup(coreDataPersistency: CoreDataPersistency)
    {
        self.coreDataPersistency = coreDataPersistency
    }
}
