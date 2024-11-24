import Foundation

protocol RecordsStoreProtocol: AnyObject {
    func getTrackerRecords(for tracker: Tracker) -> [TrackerRecord]
    func addTrackerRecord(_ record: TrackerRecord)
    func removeTrackerRecord(_ record: TrackerRecord)
}
