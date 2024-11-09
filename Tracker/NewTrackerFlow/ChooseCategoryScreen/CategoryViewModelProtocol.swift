//
//  CategoryViewModelProtocol.swift
//  Tracker
//
//  Created by Денис Максимов on 07.11.2024.
//

import Foundation

protocol CategoryViewModelProtocol: AnyObject {
    var onCategoriesListStateChange: ((CategoryIndexes) -> Void)? { get set }
    var onCategorySelected: ((String) -> Void)? { get set }
    func categoriesCount() -> Int?
    func deleteCategory(at indexPath: IndexPath)
    func getCategoryTitle(at indexPath: IndexPath) -> String?
    func selectCategory(_ category: String)
    func getDataProvider() -> DataProviderProtocol
}
