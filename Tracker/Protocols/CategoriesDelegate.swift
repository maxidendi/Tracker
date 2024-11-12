//
//  CategoriesDelegate.swift
//  Tracker
//
//  Created by Денис Максимов on 10.11.2024.
//

import Foundation

protocol CategoriesDelegate: AnyObject {
    func categoriesDidChange(_ indexes: CategoryIndexes)
}
