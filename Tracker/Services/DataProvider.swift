//
//  CategoriesAndRecordsProvider.swift
//  Tracker
//
//  Created by Денис Максимов on 26.10.2024.
//

import Foundation
import CoreData

enum UpdateTrackers {
    case insertCell([IndexPath])
    case deleteCell([IndexPath])
    case updateCell([IndexPath])
    case moveCell((from: IndexPath, to: IndexPath))
    case insertSection([Int])
    case deleteSection([Int])
    case reloadSection([Int])
}

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
        categoryStore.delegate = self
    }
    
    convenience init() {
        let context = DataProvider.persistentContainer.viewContext
        self.init(categoryStore: TrackerCategoryStore(context: context),
                  recordsStore: TrackerRecordsStore(context: context),
                  trackerStore: TrackerStore(context: context))
    }
    
    //MARK: - Properties
    
    weak var categoriesDelegate: CategoriesDelegate?
    weak var trackersDelegate: TrackersDelegate?
    private let calendar = Calendar.current
    private let categoryStore: CategoryStoreProtocol
    private let recordsStore: RecordsStoreProtocol
    private let trackerStore: TrackerStoreProtocol
    static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Trackers")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error {
                assertionFailure("Unable to load persistent stores: \(error)")
            }
        })
        return container
    } ()

    
    //MARK: - Methods
    
    //TrackerStore FRC to TrackersVC collectionView
    func fetchTrackersCoreData(for currentDate: Date) {
        let weekDay = calendar.component(.weekday, from: currentDate)
        trackerStore.fetchTrackers(for: weekDay, date: currentDate)
    }
    
    func numberOfCategories() -> Int? {
        trackerStore.trackerCoreDataFRC?.sections?.count
    }
    
    func titleForSection(_ section: Int) -> String? {
        guard let trackerCoreData = trackerStore.trackerCoreDataFRC?.sections?[section].objects?.first as? TrackerCoreData
        else { return nil }
        return trackerCoreData.category?.title
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
    
    func pinOrUnpinTracker(_ indexPath: IndexPath) {
        guard let trackerCoreData = trackerStore.trackerCoreDataFRC?.object(at: indexPath) else { return }
        if trackerCoreData.isPinned, let lastCategoryTitle = trackerCoreData.lastCategory {
            trackerCoreData.isPinned = false
            let pinnedCategoryCoreData = categoryStore.getTrackerCategoryCoreData(from: "Pinned")
            pinnedCategoryCoreData?.removeFromTrackers(trackerCoreData)
            let newCategoryCoreData = categoryStore.getTrackerCategoryCoreData(from: lastCategoryTitle)
            trackerCoreData.category = newCategoryCoreData
            trackerCoreData.lastCategory = nil
            try? DataProvider.persistentContainer.viewContext.save()
        } else {
            trackerCoreData.isPinned = true
            let lastCategoryCoreData = trackerCoreData.category
            trackerCoreData.lastCategory = lastCategoryCoreData?.title
            lastCategoryCoreData?.removeFromTrackers(trackerCoreData)
            trackerCoreData.category = categoryStore.getTrackerCategoryCoreData(from: "Pinned")
            try? DataProvider.persistentContainer.viewContext.save()
        }
    }
    
    func addTracker(_ tracker: Tracker, to category: String) {
        trackerStore.addTrackerCoreData(tracker, to: category)
    }
    
    func removeTracker(_ indexPath: IndexPath) {
        trackerStore.deleteTrackerCoreData(indexPath)
    }
    
    //CategoriesStore
    func getCategoriesList() -> [String] {
        categoryStore.getCategoriesList()
    }
    
    func addCategory(_ category: String) {
        categoryStore.addCategoryCoreData(category)
    }
    
    func removeCategory(_ index: IndexPath) {
        categoryStore.deleteCategoryCoreData(index)
    }

    //RecordsStore
    func addTrackerRecord(_ record: TrackerRecord) {
        recordsStore.addTrackerRecord(record)
    }
    
    func removeTrackerRecord(_ record: TrackerRecord) {
        recordsStore.removeTrackerRecord(record)
    }
    
    private func getRecords(for tracker: Tracker) -> [TrackerRecord] {
        recordsStore.getTrackerRecords(for: tracker)
    }
}

//MARK: - Extensions

extension DataProvider: TrackerStoreDelegate {
    func didUpdateTrackers(_ indexes: TrackerIndexes) {
        trackersDelegate?.updateTrackers(indexes)
    }
    
    func getCategoryCoreData(from category: String) -> TrackerCategoryCoreData? {
        categoryStore.getTrackerCategoryCoreData(from: category)
    }
}

extension DataProvider: TrackerCategoriesStoreDelegate {
    func didUpdateCategories(_ indexes: CategoryIndexes) {
        categoriesDelegate?.categoriesDidChange(indexes)
    }
}
