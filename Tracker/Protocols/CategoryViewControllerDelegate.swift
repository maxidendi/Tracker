//
//  CategoryViewControllerDelegate.swift
//  Tracker
//
//  Created by Денис Максимов on 18.10.2024.
//

import Foundation

protocol CategoryViewControllerDelegate: AnyObject {
    func didRecieveCategory(_ category: String)
}
