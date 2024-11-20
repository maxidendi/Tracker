//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Денис Максимов on 12.11.2024.
//

import Foundation

protocol TrackersViewModelProtocol: AnyObject {
    var onUpdateTrackers: ((TrackerIndexes) -> Void)? { get set }
    
    func updateTrackers(for date: Date)
    func updatePinnedTracker(_ index: IndexPath)
    func numberOfcategories() -> Int?
    func numberOfTrackers(for category: Int) -> Int
    func titleForCategory(_ category: Int) -> String?
    func getTrackerCellModel(at index: IndexPath) -> TrackerCellModel?
    func deleteTracker(_ index: IndexPath)
    func trackerRecordChanged(_ id: UUID, isCompleted: Bool)
    func getDataProvider() -> DataProviderProtocol
    func setupNewTrackerViewModel(for indexPath: IndexPath) -> NewTrackerViewModelProtocol?
}

final class TrackersViewModel: TrackersViewModelProtocol {
    
    //MARK: - Init
    
    init(dataProvider: DataProviderProtocol) {
        self.dataProvider = dataProvider
        self.dataProvider.trackersDelegate = self
    }

    //MARK: - Properties
    
    var onUpdateTrackers: ((TrackerIndexes) -> Void)?
    private var dataProvider: DataProviderProtocol
    private let calendar = Calendar.current
    private var currentDate: Date = Date() {
        didSet {
            dataProvider.fetchTrackersCoreData(for: currentDate)
        }
    }
    
    //MARK: - Methods
    
    func updateTrackers(for date: Date) {
        currentDate = calendar.onlyDate(from: date)
    }
    
    func updatePinnedTracker(_ index: IndexPath) {
        dataProvider.pinOrUnpinTracker(index)
    }
    
    func numberOfcategories() -> Int? {
        dataProvider.numberOfCategories()
    }
    
    func numberOfTrackers(for category: Int) -> Int {
        dataProvider.numberOfTrackersInSection(category)
    }
    
    func titleForCategory(_ category: Int) -> String? {
        dataProvider.titleForSection(category)
    }
    
    func getTrackerCellModel(at index: IndexPath) -> TrackerCellModel? {
        dataProvider.getTracker(at: index, currentDate: currentDate)
    }
    
    func deleteTracker(_ index: IndexPath) {
        dataProvider.removeTracker(index)
    }
    
    func trackerRecordChanged(_ id: UUID, isCompleted: Bool) {
        let trackerRecord = TrackerRecord(id: id, date: currentDate)
        if isCompleted {
            guard let numberOfDays = calendar.numberOfDaysBetween(currentDate),
                  numberOfDays >= .zero
            else { return }
            dataProvider.addTrackerRecord(trackerRecord)
        } else {
            dataProvider.removeTrackerRecord(trackerRecord)
        }
    }
    
    func getDataProvider() -> DataProviderProtocol {
        dataProvider
    }
    
    func setupNewTrackerViewModel(for indexPath: IndexPath) -> NewTrackerViewModelProtocol? {
        guard let trackerCellModel = getTrackerCellModel(at: indexPath)
        else { return nil }
        let isHabit = !trackerCellModel.tracker.schedule.isEmpty
        return NewTrackerViewModel(
            dataProvider: dataProvider,
            viewType: .edit(trackerCellModel),
            isHabit: isHabit)
    }
}

//MARK: - Extension

extension TrackersViewModel: TrackersDelegate {
    func updateTrackers(_ indexes: TrackerIndexes) {
        onUpdateTrackers?(indexes)
    }
}
