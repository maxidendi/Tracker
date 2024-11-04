//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Денис Максимов on 22.10.2024.
//

import UIKit
import CoreData

final class TrackerCategoryStore: NSObject, CategoryStoreProtocol {
    
    //MARK: - Init
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    //MARK: - Properties
    
    private let context: NSManagedObjectContext
    
    //MARK: - Methods
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getTrackerCategoryCoreData(from category: String) -> TrackerCategoryCoreData? {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", category)
        guard let categoryCoreData = try? context.fetch(request).first else { return nil }
        return categoryCoreData
    }
    
    func getCategoriesList() -> [String] {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.propertiesToFetch = ["title"]
        request.resultType = .dictionaryResultType
        guard let categoriesCoreData = try? context.execute(request) as? NSAsynchronousFetchResult<NSFetchRequestResult>,
              let finalResult = categoriesCoreData.finalResult as? [[String: String]] else { return [] }
        
        let categories = finalResult.compactMap{ $0["title"] }
        return categories
    }
    
    func addCategoryCoreData(_ category: String) {
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.title = category
        categoryCoreData.trackers = NSSet()
        saveContext()
    }
}
