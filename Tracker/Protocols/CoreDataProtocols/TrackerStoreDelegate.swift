import Foundation

protocol TrackerStoreDelegate: AnyObject {
    func didUpdateTrackers(_ indexes: TrackerIndexes)
    func getCategoryCoreData(from category: String) -> TrackerCategoryCoreData?
}
