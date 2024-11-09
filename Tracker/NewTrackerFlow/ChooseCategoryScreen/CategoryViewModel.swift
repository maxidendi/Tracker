//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Денис Максимов on 07.11.2024.
//

import Foundation

final class CategoryViewModel: CategoryViewModelProtocol {
    
    //MARK: - Init
    
    init(dataProvider: DataProviderProtocol) {
        self.dataProvider = dataProvider
        self.dataProvider.categoriesDelegate = self
    }
    
    //MARK: - Properties
    
    var onCategoriesListStateChange: ((CategoryIndexes) -> Void)?
    var onCategorySelected: ((String) -> Void)?
    private var dataProvider: DataProviderProtocol
    
    //MARK: - Methods
    
    func categoriesCount() -> Int? {
        dataProvider.getCategoriesList().count
    }
    
    func getCategoryTitle(at indexPath: IndexPath) -> String? {
        dataProvider.getCategory(at: indexPath)
    }
    
    func deleteCategory(at indexPath: IndexPath) {
        dataProvider.removeCategory(indexPath)
    }
    
    func selectCategory(_ category: String) {
        onCategorySelected?(category)
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
