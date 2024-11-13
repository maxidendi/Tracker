//
//  Tracker.swift
//  Tracker
//
//  Created by Денис Максимов on 01.10.2024.
//

import Foundation

struct Tracker {
    let id: UUID
    let title: String
    let color: String
    let emoji: String
    let schedule: [WeekDay]
}
