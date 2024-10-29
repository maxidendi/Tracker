//
//  RecordsStoreProtocol.swift
//  Tracker
//
//  Created by Денис Максимов on 27.10.2024.
//

import Foundation

protocol RecordsStoreProtocol: AnyObject {
    var delegate: RecordsStoreDelegate? { get set }
    var records: Set<TrackerRecord> { get }
    func addTrackerRecord(_ record: TrackerRecord)
    func removeTrackerRecord(_ record: TrackerRecord)
}
