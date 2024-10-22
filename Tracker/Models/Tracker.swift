//
//  Tracker.swift
//  Tracker
//
//  Created by Денис Максимов on 01.10.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]
    
    init(title: String, color: UIColor, emoji: String, schedule: [WeekDay]) {
        self.id = UUID()
        self.title = title
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
    }
}
