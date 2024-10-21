//
//  TrackerCategoryProvider.swift
//  Tracker
//
//  Created by Денис Максимов on 12.10.2024.
//

import Foundation

final class TrackerCategoryProvider {
    
    //MARK: - Init
    
    static let shared = TrackerCategoryProvider()
    
    private init () {}
    
    //MARK: - Properties
    
    private let queue = DispatchQueue(
        label: "customConcurrentQueue",
        qos: .userInteractive,
        attributes: .concurrent)
    var categoriesProvider: [TrackerCategory] {
        get {
            queue.sync { categories }
        }
        set {
            queue.sync(flags: .barrier) {
                categories = newValue
            }
        }
    }
    var lastId: UInt {
        var id: UInt = 0
        categories.forEach { category in
            id += UInt(category.trackers.count)
        }
        return id
    }
    private var categories: [TrackerCategory] = [
        TrackerCategory(title: "Working or just doing something good or bad i dont know",
                        trackers: [Tracker(
                                    id: 1,
                                    title: "Work hard",
                                    color: .colorSelection13,
                                    emoji: "❤️",
                                    schedule: [.friday, .saturday]),
                                   Tracker(
                                    id: 2,
                                    title: "Sport",
                                    color: .colorSelection1,
                                    emoji: "😻",
                                    schedule: [.monday])]),
        TrackerCategory(title: "Swift",
                        trackers: [Tracker(
                                    id: 7,
                                    title: "Learning swift",
                                    color: .colorSelection17,
                                    emoji: "❤️",
                                    schedule: [.tuesday, .wednesday, .thursday, .friday, .saturday, .monday]),
                                   Tracker(
                                    id: 8,
                                    title: "Sprint 14",
                                    color: .colorSelection4,
                                    emoji: "😻",
                                    schedule: [.tuesday]),
                                   Tracker(
                                    id: 9,
                                    title: "Drinking beer",
                                    color: .colorSelection17,
                                    emoji: "❤️",
                                    schedule: [.friday]),
                                    Tracker(
                                    id: 10,
                                    title: "Playing videogames",
                                    color: .colorSelection4,
                                    emoji: "😻",
                                    schedule: [.tuesday, .wednesday, .thursday, .friday])])
    ]
}
