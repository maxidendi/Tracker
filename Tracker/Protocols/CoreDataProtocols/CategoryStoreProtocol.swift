import Foundation
import CoreData

protocol CategoryStoreProtocol: AnyObject {
    var delegate: TrackerCategoriesStoreDelegate? { get set }
    var trackerCategoryCoreDataFRC: NSFetchedResultsController<TrackerCategoryCoreData> { get }
    func getCategoriesList() -> [String]
    func getTrackerCategoryCoreData(from category: String) -> TrackerCategoryCoreData?
    func addCategoryCoreData(_ category: String)
    func updateCategoryCoreData(_ category: String, withNewTitle title: String) 
    func deleteCategoryCoreData(_ index: IndexPath)
}
