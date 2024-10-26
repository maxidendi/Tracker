//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Денис Максимов on 22.10.2024.
//

import UIKit
import CoreData

final class TrackerCategoryStore: NSObject {
    
    //MARK: - Init
    
    private init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private convenience override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            fatalError("AppDelegate not found")
        }
        self.init(context: appDelegate.persistentContainer.viewContext)
    }
    
    //MARK: - Properties
    
    static let shared = TrackerCategoryStore()
    weak var delegate: TrackerCategoryStoreDelegate?
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore.shared
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchedRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title,
                                              ascending: true)
        fetchedRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchedRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let nserror = error as NSError
            assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return fetchedResultsController
    } ()
    var categories: [TrackerCategory] {
        guard let categoriesCoreData = fetchedResultsController.fetchedObjects
        else { return [] }
        let categories = categoriesCoreData.compactMap({ getTrackerCategory(from: $0) })
        return categories
    }
    
    //MARK: - Methods
    
    func saveContext() {
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
        let request = fetchedResultsController.fetchRequest
        request.predicate = NSPredicate(format: "title == %@", category)
        guard let categoryCoreData = try? context.fetch(request).first
        else { return nil }
        return categoryCoreData
    }
    
    func getTrackerCategory(from categoryCoreData: TrackerCategoryCoreData) -> TrackerCategory? {
        guard let category = categoryCoreData.title,
              let trackersSet = categoryCoreData.trackers as? Set<TrackerCoreData>
        else { return nil }
        let trackers = trackersSet.compactMap { trackerStore.getTracker(from: $0) }
        return TrackerCategory(title: category,
                               trackers: trackers)
    }
    
    func addCategoryCoreData(_ category: TrackerCategory) {
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.title = category.title
        categoryCoreData.trackers = NSSet(array: category.trackers)
        saveContext()
    }
    
    func addTrackerCoreData(_ tracker: Tracker, to category: String) {
        let trackerCoreData = trackerStore.getTrackerCoreData(from: tracker)
        guard let category = getTrackerCategoryCoreData(from: category),
              let trackers = category.trackers as? Set<TrackerCoreData>
        else {
            let newCategory = TrackerCategoryCoreData(context: context)
            newCategory.title = category
            newCategory.trackers = NSSet(array: [trackerCoreData])
            return saveContext()
        }
        let newTrackers = trackers.union([trackerCoreData])
        category.trackers = newTrackers as NSSet
        saveContext()
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateCategories()
    }
}
