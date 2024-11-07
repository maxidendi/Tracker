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
    }
    
    //MARK: - Properties
    
    var onCategoriesListStateChange: (([String]) -> Void)?
    var onCategorySelected: ((String) -> Void)?
    private let dataProvider: DataProviderProtocol
    
    //MARK: - Methods
    
    func fetchCategories() {
        onCategoriesListStateChange?(dataProvider.getCategoriesList())
    }
    
    func selectCategory(_ category: String) {
        onCategorySelected?(category)
    }
    
    func getDataProvider() -> DataProviderProtocol {
        dataProvider
    }
}
