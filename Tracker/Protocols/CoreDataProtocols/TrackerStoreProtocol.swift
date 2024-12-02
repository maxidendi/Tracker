import Foundation

protocol TrackerStoreProtocol: AnyObject {
    var delegate: TrackerStoreDelegate? { get set }
    func getTrackerCoreData(at index: IndexPath) -> TrackerCoreData?
    func fetchTrackers(for weekDay: Int, date: Date, filter: Filters, searchText: String?)
    func getFRCSectionsCount() -> Int
    func getFRCSectionTitle(at index: Int) -> String?
    func getFRCSectionObjectsCount(at index: Int) -> Int
    func getTracker(from trackerCoreData: TrackerCoreData) -> Tracker?
    func addTrackerCoreData(_ tracker: Tracker, to category: String)
    func updateTrackerCoreData(_ tracker: Tracker, asNewTracker newTracker: Tracker, for category: String)
    func deleteTrackerCoreData(_ index: IndexPath)
}
