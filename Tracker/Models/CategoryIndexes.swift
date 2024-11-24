import Foundation

struct CategoryIndexes {
    let insertedIndexes: Set<IndexPath>
    let updatedIndexes: Set<IndexPath>
    let deletedIndexes: Set<IndexPath>
    let movedIndexes: [(from: IndexPath, to: IndexPath)]
}
