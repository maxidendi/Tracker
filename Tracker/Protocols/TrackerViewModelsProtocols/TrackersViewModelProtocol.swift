import Foundation

protocol TrackersViewModelProtocol: AnyObject {
    var onUpdateTrackers: ((TrackerIndexes) -> Void)? { get set }
    var onSetDatePickerValue: ((Date) -> Void)? { get set }
    var onReloadData: (() -> Void)? { get set }
    func isFilterActive() -> Bool
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
    func setupFiltersViewController() -> FiltersViewController
    func searchTrackers(with text: String?)
}
