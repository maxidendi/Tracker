//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Денис Максимов on 07.11.2024.
//

import Foundation

final class CategoryViewModel: CategoryViewModelProtocol {
    
    //MARK: - Init
    
    init(dataProvider: DataProviderProtocol, category: String?) {
        self.dataProvider = dataProvider
        self.dataProvider.categoriesDelegate = self
        self.category = category
    }
    
    //MARK: - Properties
    
    var onCategoriesListStateChange: ((CategoryIndexes) -> Void)?
    var onCategorySelected: ((String?) -> Void)?
    var onCategoryChanged: ((String?) -> Void)?
    private var category: String? 
    private var dataProvider: DataProviderProtocol
    
    //MARK: - Methods
    
    func categoriesList() -> [String] {
        dataProvider.getCategoriesList()
    }
    
    func isCellMarked(at indexPath: IndexPath) -> Bool {
        categoriesList()[indexPath.row] == category
    }
    
    func deleteCategory(at indexPath: IndexPath) {
        if categoriesList()[indexPath.row] == category {
            category = nil
            onCategoryChanged?(category)
        }
        dataProvider.removeCategory(indexPath)
    }
    
    func selectCategory(_ indexPath: IndexPath) {
        let category = categoriesList()[indexPath.row]
        self.category = category
        onCategorySelected?(self.category)
    }
    
    func getDataProvider() -> DataProviderProtocol {
        dataProvider
    }
}

//MARK: - Extensions

extension CategoryViewModel: CategoriesDelegate {
    func categoriesDidChange(_ indexes: CategoryIndexes) {
        onCategoriesListStateChange?(indexes)
    }
}
