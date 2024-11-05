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
    
    private func getTrackerRecord(from recordCoreData: TrackerRecordCoreData) -> TrackerRecord? {
        guard let id = recordCoreData.id,
              let date = recordCoreData.date
        else { return nil }
        return TrackerRecord(id: id, date: date)
    }
    
    private func getTrackerFromId(_ id: UUID) -> TrackerCoreData? {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let tracker = try? context.fetch(request).first
        return tracker
    }
    
    func getTrackerRecords(for tracker: Tracker) -> [TrackerRecord] {
        let request = TrackerRecordCoreData.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        request.predicate = predicate
        guard let trackerRecords = try? context.fetch(request) else { return [] }
        return trackerRecords.compactMap { getTrackerRecord(from: $0) }
    }
    
    func addTrackerRecord(_ record: TrackerRecord) {
        let recordCoreData = TrackerRecordCoreData(context: context)
        recordCoreData.id = record.id
        recordCoreData.date = record.date
        let tracker = getTrackerFromId(record.id)
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
