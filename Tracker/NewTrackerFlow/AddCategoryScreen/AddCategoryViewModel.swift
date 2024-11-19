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
    var viewType: AddCategoryViewType { get }
    func doneButtonTapped()
    func checkCategoryName(_ name: String)
}

enum AddCategoryViewType {
    case add
    case edit(String)
}

final class AddCategoryViewModel: AddCategoryViewModelProtocol {
    
    //MARK: - Init
    
    init(dataProvider: DataProviderProtocol,
         viewType: AddCategoryViewType
    ) {
        self.dataProvider = dataProvider
        self.viewType = viewType
    }
    
    //MARK: - Properties
    
    var onDoneButtonStateChanged: ((Bool) -> Void)?
    var onShowAlert: ((AlertModel) -> Void)?
    let viewType: AddCategoryViewType
    private let dataProvider: DataProviderProtocol
    private var newCategory: String?
    
    //MARK: - Methods
    
    func doneButtonTapped() {
        guard let newCategory else { return }
        switch viewType {
        case .add:
            dataProvider.addCategory(newCategory)
        case .edit(let oldCategoryTitle):
            dataProvider.updateCategory(oldCategoryTitle, withNewTitle: newCategory)
        }
    }
    
    func checkCategoryName(_ name: String) {
        let categoriesList = dataProvider.getCategoriesList()
        guard !categoriesList.contains(where: { $0 == name }) && !name.isEmpty else {
            let alertModel = AlertModel(
                message: Constants.AlertModelConstants.addCategoryAlertMessage,
                actionTitle: Constants.AlertModelConstants.actionTitleOk)
            onShowAlert?(alertModel)
            onDoneButtonStateChanged?(false)
            return
        }
        self.newCategory = name
        onDoneButtonStateChanged?(true)
    }
}
