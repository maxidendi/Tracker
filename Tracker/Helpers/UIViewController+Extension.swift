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
    
    func showAlert(with model: AlertModel) {
        let alert = UIAlertController(title: nil,
                                      message: model.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: model.actionTitle, style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
