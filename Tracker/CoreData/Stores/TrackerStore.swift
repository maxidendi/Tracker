//
//  TrackerStore.swift
//  Tracker
//
//  Created by Денис Максимов on 22.10.2024.
//

import UIKit
import CoreData

final class TrackerStore: NSObject, TrackerStoreProtocol {
    
    //MARK: - Init

    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        configureFetchedResultsController()
    }
    
    //MARK: - Properties
    
    weak var delegate: TrackerStoreDelegate?
    private let context: NSManagedObjectContext
    var insertedSections = IndexSet()
    var deletedSections = IndexSet()
    var insertedIndexes: Set<IndexPath> = []
    var updatedIndexes: Set<IndexPath> = []
    var deletedIndexes: Set<IndexPath> = []
    var trackerCoreDataFRC: NSFetchedResultsController<TrackerCoreData>?

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
        insertedSections = IndexSet()
        deletedSections = IndexSet()
    }
    
    private func configureFetchedResultsController() {
        let fetchedRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        let sortDescriptorCategory = NSSortDescriptor(keyPath: \TrackerCoreData.category?.title,
                                                      ascending: true)
        fetchedRequest.sortDescriptors = [sortDescriptorCategory]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchedRequest,
            managedObjectContext: context,
            sectionNameKeyPath: #keyPath(TrackerCoreData.category.title),
            cacheName: nil)
        trackerCoreDataFRC = fetchedResultsController
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let nserror = error as NSError
            assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func fetchTrackers(for weekDay: Int, date: Date) {
        guard let trackerCoreDataFRC else { return }
        let predicate = NSPredicate(
            format: """
            (%K.@count = 0 AND (%K.@count > 0 AND ANY %K.%K = %@))
            OR (%K.@count = 0 AND %K.@count = 0)
            OR (%K.@count > 0 AND ANY %K = %ld)
            """,
            #keyPath(TrackerCoreData.weekdays),
            #keyPath(TrackerCoreData.record),
            #keyPath(TrackerCoreData.record),
            #keyPath(TrackerRecordCoreData.date),
            date as CVarArg,
            #keyPath(TrackerCoreData.weekdays),
            #keyPath(TrackerCoreData.record),
            #keyPath(TrackerCoreData.weekdays),
            #keyPath(TrackerCoreData.weekdays.weekDay),
            weekDay
        )
        trackerCoreDataFRC.fetchRequest.predicate = predicate
        try? trackerCoreDataFRC.performFetch()
    }

    func getTracker(from trackerCoreData: TrackerCoreData) -> Tracker? {
        guard let id = trackerCoreData.id,
              let title = trackerCoreData.title,
              let color = trackerCoreData.color as? UIColor,
              let emoji = trackerCoreData.emoji,
              let weekdays = trackerCoreData.weekdays as? Set<TrackerWeekDayCoreData>,
              let schedule = weekdays.compactMap({ WeekDay(from: $0.weekDay) }) as? [WeekDay]
        else { return nil }
        let tracker = Tracker(
            id: id,
            title: title,
            color: color,
            emoji: emoji,
            schedule: schedule)
        return tracker
    }
    
    func addTrackerCoreData(_ tracker: Tracker, to category: String) {
        guard let categoryCoreData =  delegate?.getCategoryCoreData(from: category)
        else { return }
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.category = categoryCoreData
        trackerCoreData.title = tracker.title
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.record = []
        tracker.schedule.forEach{
            let trackerWeekDay = TrackerWeekDayCoreData(context: context)
            trackerWeekDay.weekDay = Int32($0.toInt)
            trackerCoreData.addToWeekdays(trackerWeekDay)
        }
        saveContext()
    }
    
    func deleteTrackerCoreData(_ index: IndexPath) {
        guard let trackerCoreData = trackerCoreDataFRC?.sections?[index.section].objects?[index.row] as? TrackerCoreData
        else { return }
        context.delete(trackerCoreData)
        saveContext()
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange sectionInfo: NSFetchedResultsSectionInfo,
        atSectionIndex sectionIndex: Int,
        for type: NSFetchedResultsChangeType
    ){
        switch type {
        case .insert:
            insertedSections.insert(sectionIndex)
        case .delete:
            deletedSections.insert(sectionIndex)
        default:
            break
        }
    }
    
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
        let indexes = TrackerIndexes(
            insertedSections: insertedSections,
            deletedSections: deletedSections,
            insertedIndexes: insertedIndexes,
            updatedIndexes: updatedIndexes,
            deletedIndexes: deletedIndexes)
        delegate?.didUpdateTrackers(indexes)
        clearChanges()
    }
}
