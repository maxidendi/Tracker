//
//  CategoryStoreProtocol.swift
//  Tracker
//
//  Created by Денис Максимов on 27.10.2024.
//

import Foundation
import CoreData

protocol CategoryStoreProtocol: AnyObject {
    var delegate: TrackerCategoriesStoreDelegate? { get set }
    var trackerCategoryCoreDataFRC: NSFetchedResultsController<TrackerCategoryCoreData>? { get }
    func getCategoriesList() -> [String]
    func getTrackerCategoryCoreData(from category: String) -> TrackerCategoryCoreData?
    func addCategoryCoreData(_ category: String)
    func deleteCategoryCoreData(_ index: IndexPath)
}
