import CoreData

final class CoreDataStack {

    let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(
            name: "HealthcarePro"
        )

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")

            persistentContainer.persistentStoreDescriptions = [
                description
            ]
        }

        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError(
                    "Failed to load Core Data store: \(error)"
                )
            }
        }

        persistentContainer.viewContext
            .automaticallyMergesChangesFromParent = true
    }
}
