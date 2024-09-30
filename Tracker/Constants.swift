//
//  Constants.swift
//  Tracker
//
//  Created by Денис Максимов on 28.09.2024.
//

import Foundation


enum Constants {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    } ()
}
