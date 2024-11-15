//
//  TrackerCategoriesStoreDelegate.swift
//  Tracker
//
//  Created by Денис Максимов on 10.11.2024.
//

import Foundation

protocol TrackerCategoriesStoreDelegate: AnyObject {
    func didUpdateCategories(_ indexes: CategoryIndexes)
}
