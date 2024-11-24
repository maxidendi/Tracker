import Foundation
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
    func fetchTrackersCoreData(for currentDate: Date, filter: Filters) {
        let weekDay = calendar.component(.weekday, from: currentDate)
        trackerStore.fetchTrackers(for: weekDay, date: currentDate, filter: filter)
    }
    
    func numberOfCategories() -> Int? {
        trackerStore.trackerCoreDataFRC.sections?.count
    }
    
    func titleForSection(_ section: Int) -> String? {
        let tracker = trackerStore.trackerCoreDataFRC.sections?[section].objects?.first as? TrackerCoreData
        return tracker?.category?.title
    }
    
    func numberOfTrackersInSection(_ section: Int) -> Int {
        trackerStore.trackerCoreDataFRC.sections?[section].numberOfObjects ?? 0
    }
    
    func getTracker(at indexPath: IndexPath, currentDate: Date) -> TrackerCellModel? {
        let trackerCoreData = trackerStore.trackerCoreDataFRC.object(at: indexPath) as TrackerCoreData
        guard let tracker = trackerStore.getTracker(from: trackerCoreData),
              let categoryTitle = trackerCoreData.lastCategory != nil ?
              trackerCoreData.lastCategory :
              trackerCoreData.category?.title
        else { return nil }
        let records = getRecords(for: tracker)
        let isCompleted = records.contains(where: {
            calendar.numberOfDaysBetween($0.date, and: currentDate) == 0
        })
        let trackerCellModel = TrackerCellModel(
            tracker: tracker,
            category: categoryTitle,
            isCompleted: isCompleted,
            count: records.count)
        return trackerCellModel
    }
    
    func pinOrUnpinTracker(_ indexPath: IndexPath) {
        let trackerCoreData = trackerStore.trackerCoreDataFRC.object(at: indexPath)
        if trackerCoreData.isPinned, let lastCategoryTitle = trackerCoreData.lastCategory {
            trackerCoreData.isPinned = false
            let newCategoryCoreData = categoryStore.getTrackerCategoryCoreData(from: lastCategoryTitle)
            trackerCoreData.category = newCategoryCoreData
            trackerCoreData.lastCategory = nil
            try? DataProvider.persistentContainer.viewContext.save()
        } else {
            trackerCoreData.isPinned = true
            let lastCategoryCoreData = trackerCoreData.category
            trackerCoreData.lastCategory = lastCategoryCoreData?.title
            trackerCoreData.category = categoryStore.getTrackerCategoryCoreData(
                from: Constants.TrackersViewControllerConstants.pinnedCategoryTitle)
            try? DataProvider.persistentContainer.viewContext.save()
        }
    }
    
    func addTracker(_ tracker: Tracker, to category: String) {
        trackerStore.addTrackerCoreData(tracker, to: category)
    }
    
    func updateTracker(_ tracker: Tracker, asNewTracker newTracker: Tracker, for category: String) {
        trackerStore.updateTrackerCoreData(tracker, asNewTracker: newTracker, for: category)
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
    
    func updateCategory(_ category: String, withNewTitle title: String) {
        categoryStore.updateCategoryCoreData(category, withNewTitle: title)
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
