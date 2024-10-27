//
//  CategoryStoreProtocol.swift
//  Tracker
//
//  Created by Денис Максимов on 27.10.2024.
//

import Foundation

protocol CategoryStoreProtocol: AnyObject {
    var delegate: CategoriesStoreDelegate? { get set }
    var categories: [TrackerCategory] { get }
    func addCategoryCoreData(_ category: TrackerCategory)
    func addTrackerCoreData(_ tracker: Tracker, to category: String)
}
