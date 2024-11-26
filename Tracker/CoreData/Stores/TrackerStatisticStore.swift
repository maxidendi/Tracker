import Foundation
import CoreData

final class TrackerStatisticStore: NSObject {
    
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
    
    func getStatistic(context: NSManagedObjectContext) -> StatisticModel? {
        let request = TrackerStatisticCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(
            key: "date",
            ascending: true)]
        request.predicate = NSPredicate(
            format: "%K > 0",
            #keyPath(TrackerStatisticCoreData.trackersCount))
        guard let statisticsCoreData = try? context.fetch(request)
        else { return nil }
        let completedTrackers = statisticsCoreData.map(\.completedTrackers).reduce(0, +)
        let averageValue = statisticsCoreData.count > 0 ?
        (Double(completedTrackers) / Double(statisticsCoreData.count)).rounded(.toNearestOrAwayFromZero) : 0
        var perfectDays: Int = 0
        var bestPeriod: Int = 0
        var temporaryBestPeriod: Int = 0
        for statistic in statisticsCoreData {
            if statistic.trackersCount == statistic.completedTrackers {
                perfectDays += 1
            }
            if statistic.completedTrackers > 0 {
                temporaryBestPeriod += 1
                bestPeriod = temporaryBestPeriod
            } else {
                temporaryBestPeriod = 0
            }
        }
        return StatisticModel(
            bestPeriod: bestPeriod,
            perfectDays: perfectDays,
            completedTrackers: Int(completedTrackers),
            averageValue: Int(averageValue))
    }
}
