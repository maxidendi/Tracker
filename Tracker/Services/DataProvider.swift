//
//  CategoriesAndRecordsProvider.swift
//  Tracker
//
//  Created by Денис Максимов on 26.10.2024.
//

import Foundation

final class DataProvider: DataProviderProtocol {
    
    //MARK: - Init
    
    init(categoryStore: CategoryStoreProtocol = TrackerCategoryStore(),
         recordsStore: RecordsStoreProtocol = TrackerRecordsStore(),
         trackerStore: TrackerStoreProtocol = TrackerStore.shared
    ) {
        self.categoryStore = categoryStore
        self.recordsStore = recordsStore
        self.trackerStore = trackerStore
        categoryStore.delegate = self
        recordsStore.delegate = self
    }
    
    //MARK: - Properties
    
    weak var delegate: DataProviderDelegate?
    private let categoryStore: CategoryStoreProtocol
    private let recordsStore: RecordsStoreProtocol
    private let trackerStore: TrackerStoreProtocol
    
    //MARK: - Methods
    
    func getCategories() -> [TrackerCategory] {
        categoryStore.categories
    }
    
    func getCategoriesList() -> [String] {
        categoryStore.categories.map{ $0.title }
    }
    
    func getRecords() -> Set<TrackerRecord> {
        recordsStore.records
    }
    
    func addcategory(_ category: TrackerCategory) {
        categoryStore.addCategoryCoreData(category)
    }
    
    func addTracker(_ tracker: Tracker, to category: String) {
        categoryStore.addTrackerCoreData(tracker, to: category)
    }
    
    func addTrackerRecord(_ record: TrackerRecord) {
        recordsStore.addTrackerRecord(record)
    }
    
    func removeTrackerRecord(_ record: TrackerRecord) {
        recordsStore.removeTrackerRecord(record)
    }
}

//MARK: - Extensions

extension DataProvider: CategoriesStoreDelegate {
    func didUpdateCategories() {
        delegate?.updateCategories(categoryStore.categories)
    }
}

extension DataProvider: RecordsStoreDelegate {
    func didUpdateRecords() {
        delegate?.updateRecords(recordsStore.records)
    }
}
