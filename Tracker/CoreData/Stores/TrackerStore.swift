//
//  TrackerStore.swift
//  Tracker
//
//  Created by Денис Максимов on 22.10.2024.
//

import UIKit
import CoreData

final class TrackerStore: NSObject {
    
    //MARK: - Init
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            fatalError("AppDelegate not found")
        }
        self.init(context: appDelegate.persistentContainer.viewContext)
    }
    
    //MARK: - Properties
    
    let context: NSManagedObjectContext
    
    //MARK: - Methods
    
    func addNewTracker(_ tracker: Tracker) {
        let trackerEntity = TrackerCoreData(context: context)
        
    }
}
