import Foundation

protocol DataProviderProtocol {
    var categoriesDelegate: CategoriesDelegate? { get set }
    var trackersDelegate: TrackersDelegate? { get set }
    func fetchTrackersCoreData(for currentDate: Date, filter: Filters)
    func numberOfCategories() -> Int?
    func titleForSection(_ section: Int) -> String?
    func numberOfTrackersInSection(_ section: Int) -> Int
    func getTracker(at indexPath: IndexPath, currentDate: Date) -> TrackerCellModel?
    func getCategoriesList() -> [String]
    func addCategory(_ category: String)
    func updateCategory(_ category: String, withNewTitle title: String)
    func removeCategory(_ index: IndexPath)
    func pinOrUnpinTracker(_ indexPath: IndexPath)
    func addTracker(_ tracker: Tracker, to category: String)
    func updateTracker(_ tracker: Tracker, asNewTracker newTracker: Tracker, for category: String)
    func removeTracker(_ indexPath: IndexPath)
    func addTrackerRecord(_ record: TrackerRecord)
    func removeTrackerRecord(_ record: TrackerRecord)
    func getStatistic() -> StatisticModel?
}
