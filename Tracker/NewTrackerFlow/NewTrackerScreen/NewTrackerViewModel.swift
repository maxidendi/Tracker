import Foundation

final class NewTrackerViewModel: NewTrackerViewModelProtocol {
    
    //MARK: - Init
    
    init(dataProvider: DataProviderProtocol,
         viewType: NewTrackerViewType,
         isHabit: Bool
    ) {
        self.dataProvider = dataProvider
        self.viewType = viewType
        self.isHabit = isHabit
        setupForEditViewType()
    }

    //MARK: - Properties
    
    weak var delegate: NewTrackerViewModelDelegate?
    var onChangeTitle: ((String) -> Void)?
    var onChangeCreateButtonState: ((Bool) -> Void)?
    var onChangeSelectedEmojiCell: ((_ from: IndexPath?, _ to: IndexPath) -> Void)?
    var onChangeSelectedColorCell: ((_ from: IndexPath?, _ to: IndexPath) -> Void)?
    var onSelectCategory: ((String?, _ isSelected: Bool) -> Void)?
    var onSelectSchedule: (([WeekDay], _ isSelected: Bool) -> Void)?
    let isHabit: Bool
    let viewType: NewTrackerViewType
    private(set) var defaultCellModel: TrackerCellModel?
    private var dataProvider: DataProviderProtocol
    private var newTracker: Tracker?
    private var newTrackerCategory: String?
    private var newTrackerTitle: String?
    private var newTrackerColor: String?
    private var newTrackerEmoji: String?
    private var newTrackerSchedule: [WeekDay] = []
    private var selectedEmojiIndexPath: IndexPath?
    private var selectedColorIndexPath: IndexPath?
    private let emojiCategory: EmojiGategory = EmojiAndColors.emojiCategory
    private let colorsCategory: ColorsGategory = EmojiAndColors.colorsCategory

    //MARK: - Methods
    
    private func isReadyToCreateTracker() {
        guard let title = newTrackerTitle,
              !title.isEmpty,
              let emoji = newTrackerEmoji,
              let color = newTrackerColor,
              let _ = newTrackerCategory
        else {
            onChangeCreateButtonState?(false)
            return
        }
        let schedule = isHabit && !newTrackerSchedule.isEmpty ? newTrackerSchedule : []
        newTracker = Tracker(
            id: UUID(),
            title: title,
            color: color,
            emoji: emoji,
            isPinned: false,
            schedule: schedule)
        onChangeCreateButtonState?(true)
    }

    private func setupForEditViewType() {
        switch viewType {
        case .add:
            return
        case .edit(let trackerCellModel, _):
            defaultCellModel = trackerCellModel
            newTracker = trackerCellModel.tracker
            newTrackerCategory = trackerCellModel.category
            newTrackerTitle = trackerCellModel.tracker.title
            newTrackerColor = trackerCellModel.tracker.color
            newTrackerEmoji = trackerCellModel.tracker.emoji
            newTrackerSchedule = trackerCellModel.tracker.schedule
            guard let colorIndex = colorsCategory.colors.firstIndex(of: trackerCellModel.tracker.color),
                  let emojiIndex = emojiCategory.emoji.firstIndex(of: trackerCellModel.tracker.emoji)
            else { return }
            selectedColorIndexPath = IndexPath(row: colorIndex, section: 1)
            selectedEmojiIndexPath = IndexPath(row: emojiIndex, section: 0)
        }
    }

    func createTracker() {
        guard let newTracker, let newTrackerCategory else { return }
        switch viewType {
        case .add:
            dataProvider.addTracker(newTracker, to: newTrackerCategory)
            delegate?.dismissNewTrackerFlow()
        case .edit(let trackerCelModel, _):
            dataProvider.updateTracker(
                trackerCelModel.tracker,
                asNewTracker: newTracker,
                for: newTrackerCategory)
        }
    }
    
    func cancelButtonTapped() {
        delegate?.dismissNewTrackerFlow()
    }
    
    func getEmojiCategory() -> (emoji: [String], title: String) {
        (emoji: emojiCategory.emoji, title: emojiCategory.title)
    }
    
    func getColorCategory() -> (colors: [String], title: String) {
        (colors: colorsCategory.colors, title: colorsCategory.title)
    }
    
    func setNewTrackerTitle(_ title: String?) {
        newTrackerTitle = title
        defaultCellModel = nil
        isReadyToCreateTracker()
    }
    
    func selectEmoji(at indexPath: IndexPath) {
        if let selectedEmojiIndexPath {
            self.selectedEmojiIndexPath = indexPath
            onChangeSelectedEmojiCell?(selectedEmojiIndexPath, indexPath)
        } else {
            selectedEmojiIndexPath = indexPath
            onChangeSelectedEmojiCell?(nil, indexPath)
        }
        newTrackerEmoji = emojiCategory.emoji[indexPath.row]
        defaultCellModel = nil
        isReadyToCreateTracker()
    }
    
    func selectColor(at indexPath: IndexPath) {
        if let selectedColorIndexPath {
            self.selectedColorIndexPath = indexPath
            onChangeSelectedColorCell?(selectedColorIndexPath, indexPath)
        } else {
            selectedColorIndexPath = indexPath
            onChangeSelectedColorCell?(nil, indexPath)
        }
        newTrackerColor = colorsCategory.colors[indexPath.row]
        defaultCellModel = nil
        isReadyToCreateTracker()
    }
    
    func setupCategoryViewModel() -> CategoriesViewModel {
        let categoriesViewModel = CategoriesViewModel(dataProvider: dataProvider,
                                                      category: newTrackerCategory)
        categoriesViewModel.delegate = self
        return categoriesViewModel
    }
    
    func setupScheduleViewModel() -> ScheduleViewModel {
        let scheduleViewModel = ScheduleViewModel(schedule: Set(newTrackerSchedule))
        scheduleViewModel.delegate = self
        return scheduleViewModel
    }
}


//MARK: - Extensions

extension NewTrackerViewModel: CategoryViewModelDelegate {
    func didSelectCategory(_ category: String?, isSelected: Bool) {
        newTrackerCategory = category
        defaultCellModel = nil
        isReadyToCreateTracker()
        onSelectCategory?(newTrackerCategory, isSelected)
    }
}

extension NewTrackerViewModel: ScheduleViewModelDelegate {
    func didRecieveSchedule(_ schedule: Set<WeekDay>) {
        newTrackerSchedule = Array(schedule).sorted(by: { $0.toIntRussian < $1.toIntRussian } )
        defaultCellModel = nil
        isReadyToCreateTracker()
        onSelectSchedule?(newTrackerSchedule, true)
    }
}
