//
//  RecordsStoreProtocol.swift
//  Tracker
//
//  Created by Денис Максимов on 27.10.2024.
//

import Foundation

protocol RecordsStoreProtocol: AnyObject {
    func getTrackerRecords(for tracker: Tracker) -> [TrackerRecord]
    func addTrackerRecord(_ record: TrackerRecord)
    func removeTrackerRecord(_ record: TrackerRecord)
}
