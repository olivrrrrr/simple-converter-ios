import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    let persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "MyData")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Loading of store failed \(error)")
            }
        }

        return container
    }()
    
    @discardableResult
    func createConversion(date: Date, initialCurrency: String, initialAmount: String, secondaryCurrency: String, secondaryAmount: String) -> Conversion? {
        let context = persistentContainer.viewContext
        
        let conversion = NSEntityDescription.insertNewObject(forEntityName: "Conversion", into: context) as! Conversion
        
        conversion.date = date
        conversion.initialCurrency = initialCurrency
        conversion.initialAmount = initialAmount
        conversion.secondaryCurrency = secondaryCurrency
        conversion.secondaryAmount = secondaryAmount
        
        do {
            try context.save()
            return conversion
        } catch let createError {
            print("failed to create: \(createError)")
        }
        return nil
    }
    
    func fetchConversion() -> [Conversion]? {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Conversion>(entityName: "Conversion")
        
        do {
            let conversion = try context.fetch(fetchRequest)
            return conversion
        } catch let createError {
            print("failed to create: \(createError)")
        }
        return nil
    }

}
