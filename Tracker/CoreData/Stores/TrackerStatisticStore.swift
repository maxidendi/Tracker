import Foundation
import CoreData

final class TrackerStatisticStore: NSObject {
    
    //MARK: - Properties

    static let shared = TrackerStatisticStore()
    private let calendar = Calendar.current
    
    //MARK: - Init
    
    private override init() {}
    
    //MARK: - Methods
    
    private func getAllRecordsByDateAscending(context: NSManagedObjectContext) -> [TrackerRecordCoreData]? {
        let request = TrackerRecordCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return try? context.fetch(request)
    }
    
    private func getTrackersCountFor(date: Date, context: NSManagedObjectContext) -> Int {
        let weekDay = calendar.component(.weekday, from: date)
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K.@count > 0 AND ANY %K == %ld",
            #keyPath(TrackerCoreData.weekdays),
            #keyPath(TrackerCoreData.weekdays.weekDay),
            weekDay)
        let trackersCount = try? context.count(for: request)
        return trackersCount ?? 0
    }
    
    func getStatistic(context: NSManagedObjectContext) -> StatisticModel? {
        guard let allRecords = getAllRecordsByDateAscending(context: context),
              !allRecords.isEmpty
        else { return nil }
        let dates = allRecords.compactMap(\.date).sorted(by: <)
        let uniqueDates = Set(dates).sorted(by: <)
        let completedTrackersCount = allRecords.count
        let averageValueNotRounded = uniqueDates.count > 0 ?
        (Double(completedTrackersCount) / Double(uniqueDates.count)) : 0
        let averageValueRounded = Int((round(averageValueNotRounded * 10) / 10)
            .rounded(.toNearestOrAwayFromZero))
        let perfectDays = uniqueDates.filter{ date in
            getTrackersCountFor(date: date, context: context) == dates.filter{date == $0}.count
        }.count
        var bestPeriod = 0
        var temporaryBestPeriod = 0
        var previousDate: Date? = nil
        for date in uniqueDates {
            guard let preDate = previousDate else {
                temporaryBestPeriod = 1
                previousDate = date
                bestPeriod = max(bestPeriod, temporaryBestPeriod)
                continue
            }
            guard calendar.numberOfDaysBetween(preDate, and: date) == 1
            else {
                bestPeriod = max(bestPeriod, temporaryBestPeriod)
                continue
            }
            temporaryBestPeriod += 1
            previousDate = date
        }
        return StatisticModel(
            bestPeriod: max(bestPeriod, temporaryBestPeriod),
            perfectDays: perfectDays,
            completedTrackers: completedTrackersCount,
            averageValue: averageValueRounded)
    }
}
