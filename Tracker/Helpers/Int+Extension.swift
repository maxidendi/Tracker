//
//  Int+Extension.swift
//  Tracker
//
//  Created by Денис Максимов on 06.10.2024.
//

import Foundation

extension Int {
    private enum Days: String {
        case oneDay = "день"
        case twoThreeFourDays = "дня"
        case moreThanFourDays = "дней"
    }
    
    func toString() -> String {
        switch self {
        case self where self % 10 == 1:
            return "\(self) \(Days.oneDay.rawValue)"
        case self where self % 10 == 2 || self % 10 == 3 || self % 10 == 4:
            return "\(self) \(Days.twoThreeFourDays.rawValue)"
        case self where self % 10 > 4 || self == 0:
            return "\(self) \(Days.moreThanFourDays.rawValue)"
        default:
            return "\(self) \(Days.moreThanFourDays.rawValue)"
        }
    }
}
