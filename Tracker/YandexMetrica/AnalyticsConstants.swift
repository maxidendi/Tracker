import Foundation

enum AnalyticsEvents: String {
    case open = "open"
    case close = "close"
    case click = "click"
}

enum TrackersScreenParameters {
    static let openCloseMainScreen = ["screen": "Main"]
    static let openCloseHabitOrEventScreen = ["screen": "HabitOrEvent"]
    static let openCloseFilterScreen = ["screen": "Filter"]
    static let openCloseStatsScreen = ["screen": "Stats"]
    static let clickPlusButton = ["screen": "Main", "item": "add_tracker"]
    static let clickFilterButton = ["screen": "Main", "item": "filter"]
    static let clickMenuEdit = ["screen": "Main", "item": "edit"]
    static let clickMenuDelete = ["screen": "Main", "item": "delete"]
    static let clickCellCounterButton = ["screen": "Main", "item": "track"]
}
