//
//  UserDefaultsService.swift
//  Tracker
//
//  Created by Денис Максимов on 15.11.2024.
//

import Foundation

final class UserDefaultsService {
    
    //MARK: - Init
    static let shared = UserDefaultsService()
    private init() {}
    
    //MARK: - Properties
    private enum Keys: String {
        case isFirstLaunch
    }
    
    //MARK: - Methods
    
    func isFirstLaunch() -> Bool {
        guard UserDefaults.standard.bool(forKey: Keys.isFirstLaunch.rawValue) else {
            UserDefaults.standard.set(true, forKey: Keys.isFirstLaunch.rawValue)
            return true
        }
        return false
    }
}
