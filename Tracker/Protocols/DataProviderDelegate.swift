//
//  DataProviderDelegate.swift
//  Tracker
//
//  Created by Денис Максимов on 27.10.2024.
//

import Foundation

protocol TrackersDelegate: AnyObject {
    func updateTrackers(_ indexes: TrackerIndexes)
}

