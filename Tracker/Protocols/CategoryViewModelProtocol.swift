//
//  CategoryViewModelProtocol.swift
//  Tracker
//
//  Created by Денис Максимов on 07.11.2024.
//

import Foundation

protocol CategoryViewModelProtocol: AnyObject {
    var onCategoriesListStateChange: ((CategoryIndexes) -> Void)? { get set }
    func categoriesList() -> [String]
    func isCellMarked(at indexPath: IndexPath) -> Bool
    func deleteCategory(at indexPath: IndexPath)
    func selectCategory(_ indexPath: IndexPath)
    func getDataProvider() -> DataProviderProtocol
    func setupAddCategoryViewModel(viewType: AddCategoryViewType) -> AddCategoryViewModelProtocol
}
