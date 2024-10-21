//
//  Calendar+Extension.swift
//  Tracker
//
//  Created by Денис Максимов on 05.10.2024.
//

import Foundation

extension Calendar {
    func numberOfDaysBetween(_ start: Date, and end: Date = Date()) -> Int? {
        let currentDate = startOfDay(for: end)
        let toDate = startOfDay(for: start)
        return dateComponents([.day], from: toDate, to: currentDate).day
    }
    func onlyDate(from date: Date) -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let date = Calendar.current.date(from: components) ?? date
        return date
    }
}
