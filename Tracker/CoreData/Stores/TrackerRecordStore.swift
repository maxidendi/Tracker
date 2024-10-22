//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Денис Максимов on 22.10.2024.
//

import UIKit
import CoreData

final class TrackerRecordStore: NSObject {
    
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
    
    func addNewTrackerRecord(_ tracker: TrackerRecord) {
        let trackerEntity = TrackerRecordCoreData(context: context)
        
    }
}
