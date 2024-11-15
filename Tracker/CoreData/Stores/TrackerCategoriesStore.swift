//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Денис Максимов on 22.10.2024.
//

import Foundation
import CoreData

final class TrackerCategoryStore: NSObject, CategoryStoreProtocol {
    
    //MARK: - Init
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        configureFetchedResultsController()
    }
    
    //MARK: - Properties
    
    weak var delegate: TrackerCategoriesStoreDelegate?
    private let context: NSManagedObjectContext
    var trackerCategoryCoreDataFRC: NSFetchedResultsController<TrackerCategoryCoreData>?
    var insertedIndexes: Set<IndexPath> = []
    var updatedIndexes: Set<IndexPath> = []
    var deletedIndexes: Set<IndexPath> = []
    
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
    
    private func clearChanges() {
        insertedIndexes = []
        updatedIndexes = []
        deletedIndexes = []
    }
    
    private func configureFetchedResultsController() {
        let fetchedRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        let sortDescriptorCategory = NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title,
                                                      ascending: true)
        fetchedRequest.sortDescriptors = [sortDescriptorCategory]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchedRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        trackerCategoryCoreDataFRC = fetchedResultsController
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let nserror = error as NSError
            assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func getTrackerCategoryCoreData(from category: String) -> TrackerCategoryCoreData? {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)]
        request.predicate = NSPredicate(format: "%K = %@",
                                        #keyPath(TrackerCategoryCoreData.title),
                                        category)
        guard let categoryCoreData = try? context.fetch(request).first else { return nil }
        return categoryCoreData
    }
    
    func getCategoriesList() -> [String] {
        trackerCategoryCoreDataFRC?.fetchedObjects?.compactMap(\.title) ?? []
    }
    
    func addCategoryCoreData(_ category: String) {
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.title = category
        categoryCoreData.trackers = []
        saveContext()
    }
    
    func deleteCategoryCoreData(_ index: IndexPath) {
        guard let categoryCoreData = trackerCategoryCoreDataFRC?.fetchedObjects?[index.row] as? TrackerCategoryCoreData
        else { return }
        context.delete(categoryCoreData)
        saveContext()
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            if let newIndexPath {
                insertedIndexes.insert(newIndexPath)
            }
        case .delete:
            if let indexPath {
                deletedIndexes.insert(indexPath)
            }
        case .update:
            if let indexPath {
                updatedIndexes.insert(indexPath)
            }
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let categoryIndexes = CategoryIndexes(
            insertedIndexes: insertedIndexes,
            updatedIndexes: updatedIndexes,
            deletedIndexes: deletedIndexes)
        delegate?.didUpdateCategories(categoryIndexes)
        clearChanges()
    }
}
