//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Денис Максимов on 22.10.2024.
//

import UIKit
import CoreData

final class TrackerRecordStore: NSObject {
    
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
    
    static let shared = TrackerRecordStore()
    weak var delegate: TrackerRecordStoreDelegate?
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore.shared
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerRecordCoreData.id,
                                                    ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
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
    var records: Set<TrackerRecord> {
        let recordsCoreData = fetchedResultsController.fetchedObjects
        guard let records = recordsCoreData?.compactMap({ getTrackerRecord(from: $0) })
                else { return [] }
        return Set(records)
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
    
    func getTrackerRecord(from recordCoreData: TrackerRecordCoreData) -> TrackerRecord? {
        guard let id = recordCoreData.id,
              let date = recordCoreData.date
        else { return nil }
        return TrackerRecord(id: id, date: date)
    }
    
    func addTrackerRecord(_ record: TrackerRecord) {
        let recordCoreData = TrackerRecordCoreData(context: context)
        recordCoreData.id = record.id
        recordCoreData.date = record.date
        let tracker = trackerStore.getTrackerFromId(record.id)
        recordCoreData.tracker = tracker
        saveContext()
    }
    
    func removeTrackerRecord(_ record: TrackerRecord) {
        let request = TrackerRecordCoreData.fetchRequest()
        let predicate = NSPredicate(format: "id == %@ && date == %@",
                                    record.id as CVarArg,
                                    record.date as CVarArg)
        request.predicate = predicate
        guard let recordCoreData = try? context.fetch(request).first
        else { return }
        context.delete(recordCoreData)
        saveContext()
    }
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        delegate?.didUpdateRecords()
    }
}
