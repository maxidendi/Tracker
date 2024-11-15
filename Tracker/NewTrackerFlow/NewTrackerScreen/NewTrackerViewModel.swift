//
//  NewTrackerViewModel.swift
//  Tracker
//
//  Created by Денис Максимов on 10.11.2024.
//

import Foundation

protocol NewTrackerViewModelProtocol: AnyObject {
    var onChangeCreateButtonState: ((Bool) -> Void)? { get set }
    var onChangeSelectedEmojiCell: ((_ from: IndexPath?, _ to: IndexPath) -> Void)? { get set }
    var onChangeSelectedColorCell: ((_ from: IndexPath?, _ to: IndexPath) -> Void)? { get set }
    var onSelectSchedule: ((Set<WeekDay>) -> Void)? { get set }
    var onSelectCategory: ((String?, _ isSelected: Bool) -> Void)? { get set }
    var isHabit: Bool { get }
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

final class NewTrackerViewModel: NewTrackerViewModelProtocol {
    
    //MARK: - Init
    
    init(dataProvider: DataProviderProtocol, isHabit: Bool) {
        self.dataProvider = dataProvider
        self.isHabit = isHabit
    }

    //MARK: - Properties
    
    weak var delegate: NewTrackerViewModelDelegate?
    var onChangeCreateButtonState: ((Bool) -> Void)?
    var onChangeSelectedEmojiCell: ((_ from: IndexPath?, _ to: IndexPath) -> Void)?
    var onChangeSelectedColorCell: ((_ from: IndexPath?, _ to: IndexPath) -> Void)?
    var onSelectCategory: ((String?, _ isSelected: Bool) -> Void)?
    var onSelectSchedule: ((Set<WeekDay>) -> Void)?
    let isHabit: Bool
    private var dataProvider: DataProviderProtocol
    private var newTracker: Tracker?
    private var newTrackerCategory: String?
    private var newTrackerTitle: String?
    private var newTrackerColor: String?
    private var newTrackerEmoji: String?
    private var newTrackerSchedule: Set<WeekDay> = []
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
        if isHabit && !newTrackerSchedule.isEmpty {
            newTracker = Tracker(id: UUID(),
                                 title: title,
                                 color: color,
                                 emoji: emoji,
                                 schedule: Array(newTrackerSchedule))
            onChangeCreateButtonState?(true)
        } else if !isHabit {
            newTracker = Tracker(id: UUID(),
                                 title: title,
                                 color: color,
                                 emoji: emoji,
                                 schedule: [])
            onChangeCreateButtonState?(true)
        }
    }

    func createTracker() {
        guard let newTracker, let newTrackerCategory else { return }
        dataProvider.addTracker(newTracker, to: newTrackerCategory)
        delegate?.dismissNewTrackerFlow()
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
    
    func selectEmoji(at indexPath: IndexPath) {
        if let selectedEmojiIndexPath {
            self.selectedEmojiIndexPath = indexPath
            onChangeSelectedEmojiCell?(selectedEmojiIndexPath, indexPath)
        } else {
            selectedEmojiIndexPath = indexPath
            onChangeSelectedEmojiCell?(nil, indexPath)
        }
        newTrackerEmoji = emojiCategory.emoji[indexPath.row]
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
        isReadyToCreateTracker()
    }
    
    func setNewTrackerTitle(_ title: String?) {
        newTrackerTitle = title
        isReadyToCreateTracker()
    }
    
    func setupCategoryViewModel() -> CategoriesViewModel {
        let categoriesViewModel = CategoriesViewModel(dataProvider: dataProvider,
                                                      category: newTrackerCategory)
        categoriesViewModel.delegate = self
        return categoriesViewModel
    }
    
    func setupScheduleViewModel() -> ScheduleViewModel {
        let scheduleViewModel = ScheduleViewModel(schedule: newTrackerSchedule)
        scheduleViewModel.delegate = self
        return scheduleViewModel
    }
}


//Extension

extension NewTrackerViewModel: CategoryViewModelDelegate {
    func didSelectCategory(_ category: String?, isSelected: Bool) {
        newTrackerCategory = category
        isReadyToCreateTracker()
        onSelectCategory?(newTrackerCategory, isSelected)
    }
}

extension NewTrackerViewModel: ScheduleViewModelDelegate {
    func didRecieveSchedule(_ schedule: Set<WeekDay>) {
        newTrackerSchedule = schedule
        isReadyToCreateTracker()
        onSelectSchedule?(newTrackerSchedule)
    }
}
