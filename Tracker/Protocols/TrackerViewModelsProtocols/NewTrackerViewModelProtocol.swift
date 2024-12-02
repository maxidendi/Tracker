import Foundation

protocol NewTrackerViewModelProtocol: AnyObject {
    var onChangeTitle: ((String) -> Void)? { get set }
    var onChangeCreateButtonState: ((Bool) -> Void)? { get set }
    var onChangeSelectedEmojiCell: ((_ from: IndexPath?, _ to: IndexPath) -> Void)? { get set }
    var onChangeSelectedColorCell: ((_ from: IndexPath?, _ to: IndexPath) -> Void)? { get set }
    var onSelectSchedule: (([WeekDay], _ isSelected: Bool) -> Void)? { get set }
    var onSelectCategory: ((String?, _ isSelected: Bool) -> Void)? { get set }
    var isHabit: Bool { get }
    var viewType: NewTrackerViewType { get }
    var defaultCellModel: TrackerCellModel? { get }
    func createTracker()
    func cancelButtonTapped()
    func getEmojiCategory() -> (emoji: [String], title: String)
    func getColorCategory() -> (colors: [String], title: String)
    func selectEmoji(at indexPath: IndexPath)
    func selectColor(at indexPath: IndexPath)
    func setNewTrackerTitle(_ title: String?)
    func setupCategoryViewModel() -> CategoriesViewModel
    func setupScheduleViewModel() -> ScheduleViewModel
}
