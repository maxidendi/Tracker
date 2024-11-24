import Foundation
import CoreData

protocol TrackerStoreProtocol: AnyObject {
    var delegate: TrackerStoreDelegate? { get set }
    var trackerCoreDataFRC: NSFetchedResultsController<TrackerCoreData> { get }
    func fetchTrackers(for weekDay: Int, date: Date, filter: Filters)
    func getTracker(from trackerCoreData: TrackerCoreData) -> Tracker?
    func addTrackerCoreData(_ tracker: Tracker, to category: String)
    func updateTrackerCoreData(_ tracker: Tracker, asNewTracker newTracker: Tracker, for category: String)
    func deleteTrackerCoreData(_ index: IndexPath)
}
