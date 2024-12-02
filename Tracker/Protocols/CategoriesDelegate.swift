import Foundation

protocol CategoriesDelegate: AnyObject {
    func categoriesDidChange(_ indexes: CategoryIndexes)
}
