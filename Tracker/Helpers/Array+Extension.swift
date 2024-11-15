//
//  Array+Extension.swift
//  Tracker
//
//  Created by Денис Максимов on 12.11.2024.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
