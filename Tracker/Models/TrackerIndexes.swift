//
//  TrackerIndexes.swift
//  Tracker
//
//  Created by Денис Максимов on 08.11.2024.
//

import Foundation

struct TrackerIndexes {
    let insertedSections: IndexSet
    let deletedSections: IndexSet
    let updatedSections: IndexSet
    let insertedIndexes: Set<IndexPath>
    let updatedIndexes: Set<IndexPath>
    let deletedIndexes: Set<IndexPath>
    let movedIndexes: [(from: IndexPath, to: IndexPath)]
}
