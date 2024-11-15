//
//  AddCategoryViewModel.swift
//  Tracker
//
//  Created by Денис Максимов on 13.11.2024.
//

import Foundation

protocol AddCategoryViewModelProtocol: AnyObject {
    var onDoneButtonStateChanged: ((Bool) -> Void)? { get set }
    var onShowAlert: ((AlertModel) -> Void)? { get set }
    func doneButtonTapped()
    func checkCategoryName(_ name: String)
}

final class AddCategoryViewModel: AddCategoryViewModelProtocol {
    
    //MARK: - Init
    
    init(dataProvider: DataProviderProtocol) {
        self.dataProvider = dataProvider
    }
    
    //MARK: - Properties
    
    var onDoneButtonStateChanged: ((Bool) -> Void)?
    var onShowAlert: ((AlertModel) -> Void)?
    private let dataProvider: DataProviderProtocol
    private var newCategory: String?
    
    //MARK: - Methods
    
    func doneButtonTapped() {
        guard let newCategory else { return }
        dataProvider.addCategory(newCategory)
    }
    
    func checkCategoryName(_ name: String) {
        let categoriesList = dataProvider.getCategoriesList()
        guard !categoriesList.contains(where: { $0 == name }) && !name.isEmpty else {
            let alertModel = AlertModel(message: Constants.AlertModelConstants.messageAddCategory,
                                        actionTitle: Constants.AlertModelConstants.actionTitleAddCategory)
            onShowAlert?(alertModel)
            onDoneButtonStateChanged?(false)
            return
        }
        self.newCategory = name
        onDoneButtonStateChanged?(true)
    }
}
