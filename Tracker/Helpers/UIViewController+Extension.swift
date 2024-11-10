//
//  UIViewController+Extension.swift
//  Tracker
//
//  Created by Денис Максимов on 15.10.2024.
//

import UIKit

extension UIViewController {
    
    @objc func dissmissKeyboard() {
        view.endEditing(true)
    }
    
    func setupToHideKeyboard() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dissmissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func showAlert(with model: AlertModel,
                   alertStyle: UIAlertController.Style,
                   actionStyle: UIAlertAction.Style,
                   handler: ((UIAlertAction) -> Void)?
    ) {
        let alert = UIAlertController(title: nil,
                                      message: model.message,
                                      preferredStyle: alertStyle)
        let action = UIAlertAction(title: model.actionTitle,
                                   style: actionStyle,
                                   handler: handler)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func showAlertWithCancel(with model: AlertModel,
                             alertStyle: UIAlertController.Style,
                             actionStyle: UIAlertAction.Style,
                             handler: ((UIAlertAction) -> Void)?
    ) {
        let alert = UIAlertController(title: nil,
                                      message: model.message,
                                      preferredStyle: alertStyle)
        let action = UIAlertAction(title: model.actionTitle,
                                   style: actionStyle,
                                   handler: handler)
        let cancelAction = UIAlertAction(title: "Отменить",
                                         style: .cancel,
                                         handler: nil)
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
