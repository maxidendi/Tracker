//
//  TrackerStore.swift
//  Tracker
//
//  Created by Денис Максимов on 22.10.2024.
//

import UIKit
import CoreData

final class TrackerStore: NSObject {
    
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
    
    static let shared = TrackerStore()
    private let context: NSManagedObjectContext
    
    //MARK: - Methods
    
    func getTracker(from trackerCoreData: TrackerCoreData) -> Tracker? {
        guard let id = trackerCoreData.id,
              let title = trackerCoreData.title,
              let color = trackerCoreData.color as? UIColor,
              let emoji = trackerCoreData.emoji,
              let schedule = trackerCoreData.schedule as? [WeekDay]
        else { return nil }
        let tracker = Tracker(id: id,
                              title: title,
                              color: color,
                              emoji: emoji,
                              schedule: schedule)
        return tracker
    }
    
    func getTrackerCoreData(from tracker: Tracker) -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule as NSObject
        return trackerCoreData
    }
    
    func getTrackerFromId(_ id: UUID) -> TrackerCoreData? {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let tracker = try? context.fetch(request).first
        return tracker
    }
}
