import Foundation

struct Tracker {
    let id: UUID
    let title: String
    let color: String
    let emoji: String
    let isPinned: Bool
    let schedule: [WeekDay]
}
