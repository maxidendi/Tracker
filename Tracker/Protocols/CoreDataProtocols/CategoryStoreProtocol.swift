import Foundation

protocol CategoryStoreProtocol: AnyObject {
    var delegate: TrackerCategoriesStoreDelegate? { get set }
    func getCategoriesList() -> [String]
    func getTrackerCategoryCoreData(from category: String) -> TrackerCategoryCoreData?
    func addCategoryCoreData(_ category: String)
    func updateCategoryCoreData(_ category: String, withNewTitle title: String) 
    func deleteCategoryCoreData(_ index: IndexPath)
}
