import Foundation
import CoreData

final class TrackerStatisticStore: NSObject {
    
    enum RecordAction {
        case add
        case remove
    }
    
    //MARK: - Properties

    static let shared = TrackerStatisticStore()
    private let calendar = Calendar.current
    
    //MARK: - Init
    
    private override init() {}
    
    //MARK: - Methods
    
    private func save(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveOrUpdateTrackersCount(for date: Date, count: Int, context: NSManagedObjectContext) {
        let request = TrackerStatisticCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "date == %@", date as CVarArg)
        guard let trackerStatistic = try? context.fetch(request).first
        else {
            let trackerStatistic = TrackerStatisticCoreData(context: context)
            trackerStatistic.date = date
            trackerStatistic.trackersCount = Int32(count)
            save(context)
            print(trackerStatistic)
            return
        }
        trackerStatistic.trackersCount = Int32(count)
        save(context)
        print(trackerStatistic)
    }
    
    func updateCompletedTrackersCount(for date: Date, action: RecordAction, context: NSManagedObjectContext) {
        let request = TrackerStatisticCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "date == %@", date as CVarArg)
        guard let trackerStatistic = try? context.fetch(request).first
        else {
            return
        }
        switch action {
        case .add:
            trackerStatistic.completedTrackers += 1
        case .remove:
            trackerStatistic.completedTrackers -= 1
        }
        save(context)
        print(trackerStatistic)
    }
    
}
