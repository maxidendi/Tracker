import Foundation

enum Filters: CaseIterable {
    case allTrackers
    case todayTrackers
    case doneTrackers
    case undoneTrackers
    
    var name: String {
        switch self {
        case .allTrackers: return Constants.Filters.allTrackers
        case .todayTrackers: return Constants.Filters.todayTrackers
        case .doneTrackers: return Constants.Filters.doneTrackers
        case .undoneTrackers: return Constants.Filters.undoneTrackers
        }
    }
}
