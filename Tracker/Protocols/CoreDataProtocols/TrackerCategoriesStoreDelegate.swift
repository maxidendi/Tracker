import Foundation

protocol TrackerCategoriesStoreDelegate: AnyObject {
    func didUpdateCategories(_ indexes: CategoryIndexes)
}
