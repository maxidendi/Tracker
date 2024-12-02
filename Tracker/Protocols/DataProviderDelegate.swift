import Foundation

protocol TrackersDelegate: AnyObject {
    func updateTrackers(_ indexes: TrackerIndexes)
}

