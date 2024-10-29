//
//  HabitOrEventViewControllerDelegate.swift
//  Tracker
//
//  Created by Денис Максимов on 17.10.2024.
//

import Foundation

protocol HabitOrEventViewControllerDelegate: AnyObject {
    func getDataProvider() -> DataProviderProtocol
    func needToReloadCollectionView()
}

