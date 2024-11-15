//
//  WeekDays.swift
//  Tracker
//
//  Created by Денис Максимов on 03.10.2024.
//

import Foundation

enum WeekDay: CaseIterable, Codable {
    
    init?(from int32: Int32) {
        guard let weekDay = WeekDay.allCases.first(
            where: { $0.toIntRussian == int32 })
        else {
            return nil
        }
        self = weekDay
    }
    
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    var fullName: String {
        switch self {
        case .monday: return Constants.WeekdaySchedule.monday
        case .tuesday: return Constants.WeekdaySchedule.tuesday
        case .wednesday: return Constants.WeekdaySchedule.wednesday
        case .thursday: return Constants.WeekdaySchedule.thursday
        case .friday: return Constants.WeekdaySchedule.friday
        case .saturday: return Constants.WeekdaySchedule.saturday
        case .sunday: return Constants.WeekdaySchedule.sunday
        }
    }
    
    var shortName: String {
        switch self {
        case .monday: return Constants.WeekdaySchedule.shortMonday
        case .tuesday: return Constants.WeekdaySchedule.shortTuesday
        case .wednesday: return Constants.WeekdaySchedule.shortWednesday
        case .thursday: return Constants.WeekdaySchedule.shortThursday
        case .friday: return Constants.WeekdaySchedule.shortFriday
        case .saturday: return Constants.WeekdaySchedule.shortSaturday
        case .sunday: return Constants.WeekdaySchedule.shortSunday
        }
    }
    
    var toInt: Int {
        switch self {
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
        case .sunday: return 1
        }
    }
    
    var toIntRussian: Int {
        switch self {
        case .monday: return 1
        case .tuesday: return 2
        case .wednesday: return 3
        case .thursday: return 4
        case .friday: return 5
        case .saturday: return 6
        case .sunday: return 7
        }
    }
}
