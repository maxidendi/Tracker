//
//  CategoriesAndRecordsProvider.swift
//  Tracker
//
//  Created by Денис Максимов on 26.10.2024.
//

import UIKit
import CoreData

final class DataProvider: DataProviderProtocol {
    
    //MARK: - Init
    
    init(categoryStore: CategoryStoreProtocol,
         recordsStore: RecordsStoreProtocol,
         trackerStore: TrackerStoreProtocol
    ) {
        self.categoryStore = categoryStore
        self.recordsStore = recordsStore
        self.trackerStore = trackerStore
        trackerStore.delegate = self
    }
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            assertionFailure("no AppDelegate")
            self.init()
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        self.init(categoryStore: TrackerCategoryStore(context: context),
                  recordsStore: TrackerRecordsStore(context: context),
                  trackerStore: TrackerStore(context: context))
    }
    
    //MARK: - Properties
    
    weak var delegate: DataProviderDelegate?
    private let calendar = Calendar.current
    private let categoryStore: CategoryStoreProtocol
    private let recordsStore: RecordsStoreProtocol
    private let trackerStore: TrackerStoreProtocol
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Trackers")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        })
        return container
    } ()
    
    //MARK: - Methods
    
    //TrackerStore FRC
    
    func fetchTrackersCoreData(_ weekDay: Int, currentDate: Date) {
        trackerStore.fetchTrackers(for: weekDay, date: currentDate)
    }
    
    func numberOfCategories() -> Int? {
        trackerStore.trackerCoreDataFRC?.sections?.count
    }
    
    func titleForSection(_ section: Int) -> String? {
        let trackerCoreData = trackerStore.trackerCoreDataFRC?.sections?[section].objects?[0] as? TrackerCoreData
        return trackerCoreData?.category?.title
    }
    
    func numberOfTrackersInSection(_ section: Int) -> Int {
        trackerStore.trackerCoreDataFRC?.sections?[section].numberOfObjects ?? 0
    }
    
    func getTracker(at indexPath: IndexPath, currentDate: Date) -> TrackerCellModel? {
        guard let trackerCoreData = trackerStore.trackerCoreDataFRC?.object(at: indexPath) as? TrackerCoreData,
              let tracker = trackerStore.getTracker(from: trackerCoreData)
        else { return nil }
        let records = getRecords(for: tracker)
        let isCompleted = records.contains(where: {
            calendar.numberOfDaysBetween($0.date, and: currentDate) == 0
        })
        let trackerCellModel = TrackerCellModel(
            tracker: tracker,
            isCompleted: isCompleted,
            count: records.count)
        return trackerCellModel
    }
    
    //Other Stores
    
    func getCategoriesList() -> [String] {
        categoryStore.getCategoriesList()
    }
    
    func getRecords(for tracker: Tracker) -> [TrackerRecord] {
        recordsStore.getTrackerRecords(for: tracker)
    }
    
    func addCategory(_ category: String) {
        categoryStore.addCategoryCoreData(category)
    }
    
    func addTracker(_ tracker: Tracker, to category: String) {
        trackerStore.addTrackerCoreData(tracker, to: category)
    }
    
    func addTrackerRecord(_ record: TrackerRecord) {
        recordsStore.addTrackerRecord(record)
    }
    
    func removeTrackerRecord(_ record: TrackerRecord) {
        recordsStore.removeTrackerRecord(record)
    }
}

//MARK: - Extensions

extension DataProvider: TrackerStoreDelegate {
    func didUpdateTrackers() {
        delegate?.updateTrackers()
    }
    
    func getCategoryCoreData(from category: String) -> TrackerCategoryCoreData? {
        categoryStore.getTrackerCategoryCoreData(from: category)
    }
}
