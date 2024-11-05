//
//  CategoryStoreProtocol.swift
//  Tracker
//
//  Created by Денис Максимов on 27.10.2024.
//

import Foundation

protocol CategoryStoreProtocol: AnyObject {
    func getCategoriesList() -> [String]
    func getTrackerCategoryCoreData(from category: String) -> TrackerCategoryCoreData?
    func addCategoryCoreData(_ category: String)
}
