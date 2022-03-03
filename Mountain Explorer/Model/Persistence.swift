//
//  Persistence.swift
//  Mountain app
//
//  Created by Pavel Sharenda on 22.02.22.
//

import CoreData
import UIKit

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let peak = Peak(context: viewContext)
        peak.title = "Himalayas"
        peak.descript = "The Himalayas, or Himalaya, are a mountain range in Asia separating the plains of the Indian subcontinent from the Tibetan Plateau. The range has some of the planet's highest peaks, including the highest, Mount Everest. Over 100 peaks exceeding 7,200 m in elevation lie in the Himalayas."
        peak.elevation = 7200
        peak.image = (UIImage(named: "Himalayas")?.pngData())!
        peak.location = "🇮🇳 India"
        peak.link = "https://en.wikipedia.org/wiki/Himalayas"
        peak.coordinates = "27.59, 86.55"
        peak.rating = .awesome
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    static var testData: [Peak]? = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Peak")
        return try? PersistenceController.preview.container.viewContext.fetch(fetchRequest) as? [Peak]
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Mountain_Explorer")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
