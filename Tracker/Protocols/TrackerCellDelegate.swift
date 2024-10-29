//
//  TrackerCellDelegate.swift
//  Tracker
//
//  Created by Денис Максимов on 17.10.2024.
//

import Foundation

protocol TrackerCellDelegate: AnyObject {
    func counterButtonTapped(with id: UUID, isCompleted: Bool, completion: @escaping () -> Void)
}
