import Foundation
import CoreData

final class TrackerStore: NSObject, TrackerStoreProtocol {
    
    //MARK: - Init

    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    //MARK: - Properties
    
    weak var delegate: TrackerStoreDelegate?
    private var currentDate: Date = Date()
    private let context: NSManagedObjectContext
    private var insertedSections = IndexSet()
    private var deletedSections = IndexSet()
    private var updatedSections = IndexSet()
    private var insertedIndexes: Set<IndexPath> = []
    private var deletedIndexes: Set<IndexPath> = []
    private var updatedIndexes: Set<IndexPath> = []
    private var movedIndexes: [(from: IndexPath, to: IndexPath)] = []
    lazy var trackerCoreDataFRC: NSFetchedResultsController<TrackerCoreData> = {
        let fetchedRequest = TrackerCoreData.fetchRequest()
        let sortDescriptorCategoryTitle = NSSortDescriptor(
            keyPath: \TrackerCoreData.title,
            ascending: true)
        let sortDescriptorCategoryDate = NSSortDescriptor(
            keyPath: \TrackerCoreData.category?.createdAt,
            ascending: false)
        fetchedRequest.sortDescriptors = [sortDescriptorCategoryDate, sortDescriptorCategoryTitle]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchedRequest,
            managedObjectContext: context,
            sectionNameKeyPath: #keyPath(TrackerCoreData.category.createdAt),
            cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let nserror = error as NSError
            assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return fetchedResultsController
    } ()

    //MARK: - Methods
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func updateStatisticTrackersCount() {
        let trackerscount = trackerCoreDataFRC.fetchedObjects?.count ?? 0
        TrackerStatisticStore.shared.saveOrUpdateTrackersCount(
            for: currentDate,
            count: trackerscount,
            context: context)
    }
    
    private func clearChanges() {
        insertedIndexes = []
        updatedIndexes = []
        deletedIndexes = []
        movedIndexes = []
        insertedSections = IndexSet()
        deletedSections = IndexSet()
        updatedSections = IndexSet()
    }
    
    func fetchTrackers(for weekDay: Int, date: Date, filter: Filters) {
        let predicate: NSPredicate
        switch filter {
        case .todayTrackers:
            fallthrough
        case .allTrackers:
            predicate = NSPredicate(
                format: """
                (%K.@count = 0 AND (%K.@count > 0 AND ANY %K.%K = %@))
                OR (%K.@count = 0 AND %K.@count = 0)
                OR (%K.@count > 0 AND ANY %K = %ld)
                """,
                #keyPath(TrackerCoreData.weekdays),
                #keyPath(TrackerCoreData.record),
                #keyPath(TrackerCoreData.record),
                #keyPath(TrackerRecordCoreData.date),
                date as NSDate,
                #keyPath(TrackerCoreData.weekdays),
                #keyPath(TrackerCoreData.record),
                #keyPath(TrackerCoreData.weekdays),
                #keyPath(TrackerCoreData.weekdays.weekDay),
                weekDay
            )
        case .doneTrackers:
            predicate = NSPredicate(
                format: """
                ((%K.@count = 0 AND %K.@count > 0)
                OR (%K.@count > 0 AND ANY %K = %ld)) AND ANY %K.%K = %@
                """,
                #keyPath(TrackerCoreData.weekdays),
                #keyPath(TrackerCoreData.record),
                #keyPath(TrackerCoreData.weekdays),
                #keyPath(TrackerCoreData.weekdays.weekDay),
                weekDay,
                #keyPath(TrackerCoreData.record),
                #keyPath(TrackerRecordCoreData.date),
                date as NSDate
            )
        case .undoneTrackers:
            predicate = NSPredicate(
                format: """
                (%K.@count = 0 AND %K.@count = 0)
                OR ((%K.@count > 0 AND ANY %K = %ld) AND 
                (SUBQUERY(record, $record, $record.date == %@).@count == 0) OR %K.@count = 0)
                """,
                #keyPath(TrackerCoreData.weekdays),
                #keyPath(TrackerCoreData.record),
                #keyPath(TrackerCoreData.weekdays),
                #keyPath(TrackerCoreData.weekdays.weekDay),
                weekDay,
                date as NSDate,
                #keyPath(TrackerCoreData.record)
            )
        }
        trackerCoreDataFRC.fetchRequest.predicate = predicate
        do {
            try trackerCoreDataFRC.performFetch()
            currentDate = date
            if filter == .allTrackers || filter == .todayTrackers {
                updateStatisticTrackersCount()
            }
        } catch {
            assertionFailure("Error fetching trackers: \(error)")
        }
    }

    func getTracker(from trackerCoreData: TrackerCoreData) -> Tracker? {
        guard let id = trackerCoreData.id,
              let title = trackerCoreData.title,
              let color = trackerCoreData.color,
              let emoji = trackerCoreData.emoji,
              let weekdays = trackerCoreData.weekdays as? Set<TrackerWeekDayCoreData>,
              let schedule = weekdays.compactMap({ WeekDay(from: $0.weekDay) }) as? [WeekDay]
        else { return nil }
        let tracker = Tracker(
            id: id,
            title: title,
            color: color,
            emoji: emoji,
            isPinned: trackerCoreData.isPinned,
            schedule: schedule)
        return tracker
    }
    
    func addTrackerCoreData(_ tracker: Tracker, to category: String) {
        guard let categoryCoreData =  delegate?.getCategoryCoreData(from: category)
        else { return }
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.category = categoryCoreData
        trackerCoreData.title = tracker.title
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.record = []
        tracker.schedule.forEach{
            let trackerWeekDay = TrackerWeekDayCoreData(context: context)
            trackerWeekDay.weekDay = Int32($0.toInt)
            trackerCoreData.addToWeekdays(trackerWeekDay)
        }
        saveContext()
        updateStatisticTrackersCount()
    }
    
    func updateTrackerCoreData(_ tracker: Tracker, asNewTracker newTracker: Tracker, for category: String) {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        guard let trackerCoreData = try? context.fetch(request).first
        else {
            addTrackerCoreData(tracker, to: category)
            return
        }
        guard let categoryCoreData =  delegate?.getCategoryCoreData(from: category),
              let weekdays = trackerCoreData.weekdays as? Set<TrackerWeekDayCoreData>
        else { return }
        trackerCoreData.title = newTracker.title
        trackerCoreData.color = newTracker.color
        trackerCoreData.emoji = newTracker.emoji
        weekdays.forEach{ context.delete($0) }
        newTracker.schedule.forEach{
            let trackerWeekDay = TrackerWeekDayCoreData(context: context)
            trackerWeekDay.weekDay = Int32($0.toInt)
            trackerCoreData.addToWeekdays(trackerWeekDay)
        }
        if trackerCoreData.lastCategory == nil {
            trackerCoreData.category = categoryCoreData
        } else {
            trackerCoreData.lastCategory = categoryCoreData.title
        }
        saveContext()
        updateStatisticTrackersCount()
    }
    
    func deleteTrackerCoreData(_ index: IndexPath) {
        let trackerCoreData = trackerCoreDataFRC.object(at: index) as TrackerCoreData
        if let records = trackerCoreData.record as? Set<TrackerRecordCoreData>,
           !records.isEmpty {
            records.compactMap(\.date).forEach{
                TrackerStatisticStore.shared.updateCompletedTrackersCount(
                    for: $0,
                    action: .remove,
                    context: context)
            }
        }
        context.delete(trackerCoreData)
        saveContext()
        updateStatisticTrackersCount()
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange sectionInfo: NSFetchedResultsSectionInfo,
        atSectionIndex sectionIndex: Int,
        for type: NSFetchedResultsChangeType
    ){
        switch type {
        case .insert:
            insertedSections.insert(sectionIndex)
        case .delete:
            deletedSections.insert(sectionIndex)
        case .update:
            updatedSections.insert(sectionIndex)
        default:
            break
        }
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            if let newIndexPath {
                insertedIndexes.insert(newIndexPath)
            }
        case .delete:
            if let indexPath {
                deletedIndexes.insert(indexPath)
            }
        case .update:
            if let indexPath {
                updatedIndexes.insert(indexPath)
            }
        case .move:
            if let indexPath, let newIndexPath {
                movedIndexes.append((indexPath, newIndexPath))
            }
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let indexes = TrackerIndexes(
            insertedSections: insertedSections,
            deletedSections: deletedSections,
            updatedSections: updatedSections,
            insertedIndexes: insertedIndexes,
            updatedIndexes: updatedIndexes,
            deletedIndexes: deletedIndexes,
            movedIndexes: movedIndexes)
        delegate?.didUpdateTrackers(indexes)
        clearChanges()
    }
}
