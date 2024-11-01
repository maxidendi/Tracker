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
    
    init(delegate: CategoriesStoreDelegate? = nil) {
        self.delegate = delegate
        super.init()
        configureFetchedResultsController()
    }
    
    //MARK: - Properties
    
    weak var delegate: CategoriesStoreDelegate?
    private let context = TrackerStore.shared.persistentContainer.viewContext
    private let trackerStore = TrackerStore.shared
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>?
    
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
    
    private func configureFetchedResultsController() {
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
            self.fetchedResultsController = fetchedResultsController
        } catch {
            let nserror = error as NSError
            assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    private func getTrackerCategoryCoreData(from category: String) -> TrackerCategoryCoreData? {
        guard let request = fetchedResultsController?.fetchRequest else { return nil }
        request.predicate = NSPredicate(format: "title == %@", category)
        guard let categoryCoreData = try? context.fetch(request).first else { return nil }
        return categoryCoreData
    }
    
    private func getTrackerCategory(from categoryCoreData: TrackerCategoryCoreData) -> TrackerCategory? {
        guard let category = categoryCoreData.title,
              let trackersSet = categoryCoreData.trackers as? Set<TrackerCoreData>
        else { return nil }
        let trackers = trackersSet.compactMap { trackerStore.getTracker(from: $0) }
        return TrackerCategory(title: category,
                               trackers: trackers)
    }

    func getCategories() -> [TrackerCategory] {
        guard let categoriesCoreData = fetchedResultsController?.fetchedObjects else { return [] }
        let categories = categoriesCoreData.compactMap({ getTrackerCategory(from: $0) })
        return categories
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
