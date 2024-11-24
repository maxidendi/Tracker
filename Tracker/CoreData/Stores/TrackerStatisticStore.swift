import Foundation
import CoreData

final class TrackerStatisticStore: NSObject {
    
    static let shared = TrackerStatisticStore()
    private let calendar = Calendar.current
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
            return
        }
        trackerStatistic.trackersCount = Int32(count)
        save(context)
    }
    
    
}
