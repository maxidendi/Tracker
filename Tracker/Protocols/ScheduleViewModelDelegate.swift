//
//  ScheduleViewControllerDelegate.swift
//  Tracker
//
//  Created by Денис Максимов on 17.10.2024.
//

import Foundation

protocol ScheduleViewModelDelegate: AnyObject {
    func didRecieveSchedule(_ schedule: Set<WeekDay>)
}
