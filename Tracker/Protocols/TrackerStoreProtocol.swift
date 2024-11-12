//
//  TrackerStoreProtocol.swift
//  Tracker
//
//  Created by Денис Максимов on 27.10.2024.
//

import Foundation
import CoreData

protocol TrackerStoreProtocol: AnyObject {
    var delegate: TrackerStoreDelegate? { get set }
    var trackerCoreDataFRC: NSFetchedResultsController<TrackerCoreData>? { get }
    func fetchTrackers(for weekDay: Int, date: Date)
    func getTracker(from trackerCoreData: TrackerCoreData) -> Tracker?
    func addTrackerCoreData(_ tracker: Tracker, to category: String)
    func deleteTrackerCoreData(_ index: IndexPath)
}
