//
//  DataProviderProtocol.swift
//  Tracker
//
//  Created by Денис Максимов on 27.10.2024.
//

import Foundation

protocol DataProviderProtocol {
    var delegate: DataProviderDelegate? { get set }
    func fetchTrackersCoreData(_ weekDay: Int, currentDate: Date)
    func numberOfCategories() -> Int?
    func titleForSection(_ section: Int) -> String?
    func numberOfTrackersInSection(_ section: Int) -> Int
    func getTracker(at indexPath: IndexPath, currentDate: Date) -> TrackerCellModel?
    func getCategoriesList() -> [String]
    func addCategory(_ category: String)
    func addTracker(_ tracker: Tracker, to category: String)
    func addTrackerRecord(_ record: TrackerRecord)
    func removeTrackerRecord(_ record: TrackerRecord)
}
