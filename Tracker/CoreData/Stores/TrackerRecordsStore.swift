//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Денис Максимов on 22.10.2024.
//

import UIKit
import CoreData

final class TrackerRecordsStore: NSObject, RecordsStoreProtocol {
    
    //MARK: - Init
    
    init(delegate: RecordsStoreDelegate? = nil) {
        self.delegate = delegate
        super.init()
        configureFetchedResultsController()
    }
    
    //MARK: - Properties
    
    weak var delegate: RecordsStoreDelegate?
    private let context = TrackerStore.shared.persistentContainer.viewContext
    private let trackerStore = TrackerStore.shared
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>?
    var records: Set<TrackerRecord> {
        let recordsCoreData = fetchedResultsController?.fetchedObjects
        guard let records = recordsCoreData?.compactMap({ getTrackerRecord(from: $0) })
                else { return [] }
        return Set(records)
    }

    
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
            self.fetchedResultsController = fetchedResultsController
        } catch {
            let nserror = error as NSError
            assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    private func getTrackerRecord(from recordCoreData: TrackerRecordCoreData) -> TrackerRecord? {
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

extension TrackerRecordsStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        delegate?.didUpdateRecords()
    }
}
