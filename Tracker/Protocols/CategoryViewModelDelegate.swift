//
//  CategoryViewControllerDelegate.swift
//  Tracker
//
//  Created by Денис Максимов on 18.10.2024.
//

import Foundation

protocol CategoryViewModelDelegate: AnyObject {
    func didSelectCategory(_ category: String?)
    func didRecieveCategory(_ category: String?)
}
