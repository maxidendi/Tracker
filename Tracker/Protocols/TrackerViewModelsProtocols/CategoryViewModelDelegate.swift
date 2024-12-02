import Foundation

protocol CategoryViewModelDelegate: AnyObject {
    func didSelectCategory(_ category: String?, isSelected: Bool)
}
