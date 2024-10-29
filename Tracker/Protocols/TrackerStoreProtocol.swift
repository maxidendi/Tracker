//
//  TrackerStoreProtocol.swift
//  Tracker
//
//  Created by Денис Максимов on 27.10.2024.
//

import Foundation

protocol TrackerStoreProtocol: AnyObject {
    func getTracker(from trackerCoreData: TrackerCoreData) -> Tracker?
    func getTrackerCoreData(from tracker: Tracker) -> TrackerCoreData
    func getTrackerFromId(_ id: UUID) -> TrackerCoreData?
}
