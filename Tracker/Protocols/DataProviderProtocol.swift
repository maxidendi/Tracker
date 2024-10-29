//
//  DataProviderProtocol.swift
//  Tracker
//
//  Created by Денис Максимов on 27.10.2024.
//

import Foundation

protocol DataProviderProtocol {
    var delegate: DataProviderDelegate? { get set }
    func getCategories() -> [TrackerCategory]
    func getCategoriesList() -> [String]
    func getRecords() -> Set<TrackerRecord>
    func addcategory(_ category: TrackerCategory)
    func addTracker(_ tracker: Tracker, to category: String)
    func addTrackerRecord(_ record: TrackerRecord)
    func removeTrackerRecord(_ record: TrackerRecord)
}
