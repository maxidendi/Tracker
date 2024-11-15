//
//  TrackerStoreDelegate.swift
//  Tracker
//
//  Created by Денис Максимов on 06.11.2024.
//

import Foundation

protocol TrackerStoreDelegate: AnyObject {
    func didUpdateTrackers(_ indexes: TrackerIndexes)
    func getCategoryCoreData(from category: String) -> TrackerCategoryCoreData?
}
