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
