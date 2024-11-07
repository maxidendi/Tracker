//
//  CategoryViewModelProtocol.swift
//  Tracker
//
//  Created by Денис Максимов on 07.11.2024.
//

import Foundation

protocol CategoryViewModelProtocol: AnyObject {
    var onCategoriesListStateChange: (([String]) -> Void)? { get set }
    var onCategorySelected: ((String) -> Void)? { get set }
    func fetchCategories()
    func selectCategory(_ category: String)
    func getDataProvider() -> DataProviderProtocol
}
