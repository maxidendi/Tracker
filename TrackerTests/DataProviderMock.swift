import Foundation
@testable import Tracker

final class DataProviderMock: DataProviderProtocol {
    var categoriesDelegate: CategoriesDelegate?
    var trackersDelegate: TrackersDelegate?
    func fetchTrackersCoreData(for currentDate: Date, filter: Filters) {}
    func numberOfCategories() -> Int { 0 }
    func titleForSection(_ section: Int) -> String? { nil }
    func numberOfTrackersInSection(_ section: Int) -> Int { 0 }
    func getTracker(at indexPath: IndexPath, currentDate: Date) -> TrackerCellModel? { nil }
    func getCategoriesList() -> [String] { [] }
    func addCategory(_ category: String) {}
    func updateCategory(_ category: String, withNewTitle title: String) {}
    func removeCategory(_ index: IndexPath) {}
    func pinOrUnpinTracker(_ indexPath: IndexPath) {}
    func addTracker(_ tracker: Tracker, to category: String) {}
    func updateTracker(_ tracker: Tracker, asNewTracker newTracker: Tracker, for category: String) {}
    func removeTracker(_ indexPath: IndexPath) {}
    func addTrackerRecord(_ record: TrackerRecord) {}
    func removeTrackerRecord(_ record: TrackerRecord) {}
    func getStatistic() -> StatisticModel? { nil }
}
