//
//  DataProviderDelegate.swift
//  Tracker
//
//  Created by Денис Максимов on 27.10.2024.
//

import Foundation

protocol DataProviderDelegate: AnyObject {
    
    func updateCategories(_ categories: [TrackerCategory])
    func updateRecords(_ records: Set<TrackerRecord>)
}

