import Foundation
import CoreData

final class TrackerStatisticStore: NSObject {
    
    //MARK: - Properties

    static let shared = TrackerStatisticStore()
    private let calendar = Calendar.current
    
    //MARK: - Init
    
    private override init() {}
    
    //MARK: - Methods
    
    func saveOrUpdateTrackersCountWithoutSave(
        for date: Date,
        count: Int,
        context: NSManagedObjectContext
    ) {
        let request = TrackerStatisticCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "date == %@", date as CVarArg)
        guard let trackerStatistic = try? context.fetch(request).first
        else {
            let trackerStatistic = TrackerStatisticCoreData(context: context)
            trackerStatistic.date = date
            trackerStatistic.trackersCount = Int32(count)
            return
        }
        trackerStatistic.trackersCount = Int32(count)
    }
    
    func updateCompletedTrackersCountWithoutSave(
        for date: Date,
        action: StatisticRecordAction,
        context: NSManagedObjectContext
    ) {
        let request = TrackerStatisticCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "date == %@", date as CVarArg)
        guard let trackerStatistic = try? context.fetch(request).first
        else {
            return
        }
        switch action {
        case .add:
            trackerStatistic.completedTrackers += 1
        case .remove(let withTracker):
            trackerStatistic.completedTrackers -= 1
            if withTracker {
                trackerStatistic.trackersCount -= 1
            }
        }
    }
    
    func getStatistic(context: NSManagedObjectContext) -> StatisticModel? {
        let request = TrackerStatisticCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(
            key: "date",
            ascending: true)]
        request.predicate = NSPredicate(
            format: "%K > 0 ",
            #keyPath(TrackerStatisticCoreData.trackersCount))
        guard let statisticsCoreData = try? context.fetch(request),
              statisticsCoreData.map({ $0.trackersCount }).reduce(0, +) > 0
        else { return nil }
        let completedTrackers = Int(statisticsCoreData.map(\.completedTrackers).reduce(0, +))
        let averageValueNotRounded = statisticsCoreData.count > 0 ?
        (Double(completedTrackers) / Double(statisticsCoreData.count)) : 0
        let averageValueRounded = Int((round(averageValueNotRounded * 10) / 10).rounded(.toNearestOrAwayFromZero))
        var perfectDays: Int = 0
        var bestPeriod: Int = 0
        var previousDate: Date? = nil
        var temporaryBestPeriod: Int = 0
        for statistic in statisticsCoreData {
            if statistic.trackersCount == statistic.completedTrackers {
                perfectDays += 1
            }
            if let temporaryDate = previousDate {
                if statistic.completedTrackers > 0,
                   let currentDate = statistic.date,
                   let diffDays = Calendar.current.numberOfDaysBetween(temporaryDate, and: currentDate),
                   diffDays == 1
                {
                    temporaryBestPeriod += 1
                } else {
                    bestPeriod = max(bestPeriod, temporaryBestPeriod)
                    temporaryBestPeriod = 0
                    previousDate = nil
                }
            } else {
                temporaryBestPeriod = 1
            }
            previousDate = statistic.date
        }
        return StatisticModel(
            bestPeriod: max(bestPeriod, temporaryBestPeriod),
            perfectDays: perfectDays,
            completedTrackers: completedTrackers,
            averageValue: averageValueRounded)
    }
}
