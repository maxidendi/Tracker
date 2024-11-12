//
//  NewTrackerViewModel.swift
//  Tracker
//
//  Created by Денис Максимов on 10.11.2024.
//

import UIKit

protocol NewTrackerViewModelProtocol: AnyObject {
    var onChangeCreateButtonState: ((Bool) -> Void)? { get set }
    var onNewTrackerCreated: (() -> Void)? { get set }
    var onChangeSelectedEmojiCell: ((_ from: IndexPath?, _ to: IndexPath) -> Void)? { get set }
    var onChangeSelectedColorCell: ((_ from: IndexPath?, _ to: IndexPath) -> Void)? { get set }
    var onChangeCategory: ((String?) -> Void)? { get set }
    var onSelectSchedule: ((Set<WeekDay>) -> Void)? { get set }
    var onSelectCategory: ((String?) -> Void)? { get set }
    var onShowCategoryView: ((CategoryViewModel) -> Void)? { get set }
    var onShowScheduleView: ((ScheduleViewModel) -> Void)? { get set }
    var isHabit: Bool { get }
    func createTracker()
    func getEmojiCategory() -> (emoji: [String], title: String)
    func getColorCategory() -> (colors: [UIColor], title: String)
    func selectEmoji(at indexPath: IndexPath)
    func selectColor(at indexPath: IndexPath)
    func setCategoryDetailTitle()
    func setNewTrackerTitle(_ title: String?)
    func setupCategoryViewModel()
    func setupScheduleViewModel()
}

final class NewTrackerViewModel: NewTrackerViewModelProtocol {
    
    //MARK: - Init
    
    init(dataProvider: DataProviderProtocol, isHabit: Bool) {
        self.dataProvider = dataProvider
        self.isHabit = isHabit
    }

    //MARK: - Properties
    
    var onChangeCreateButtonState: ((Bool) -> Void)?
    var onNewTrackerCreated: (() -> Void)?
    var onChangeSelectedEmojiCell: ((_ from: IndexPath?, _ to: IndexPath) -> Void)?
    var onChangeSelectedColorCell: ((_ from: IndexPath?, _ to: IndexPath) -> Void)?
    var onChangeCategory: ((String?) -> Void)?
    var onSelectCategory: ((String?) -> Void)?
    var onSelectSchedule: ((Set<WeekDay>) -> Void)?
    var onShowCategoryView: ((CategoryViewModel) -> Void)?
    var onShowScheduleView: ((ScheduleViewModel) -> Void)?
    let isHabit: Bool
    private var dataProvider: DataProviderProtocol
    private var newTracker: Tracker?
    private var newTrackerCategory: String?
    private var newTrackerTitle: String?
    private var newTrackerColor: UIColor?
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
        onNewTrackerCreated?()
    }
    
    func getEmojiCategory() -> (emoji: [String], title: String) {
        (emoji: emojiCategory.emoji, title: emojiCategory.title)
    }
    
    func getColorCategory() -> (colors: [UIColor], title: String) {
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
    
    func setCategoryDetailTitle() {
        onChangeCategory?(newTrackerCategory)
    }
    
    func setScheduleDetailTitle() {
        onSelectSchedule?(newTrackerSchedule)
    }
    
    func setNewTrackerTitle(_ title: String?) {
        newTrackerTitle = title
        isReadyToCreateTracker()
    }
    
    func setupCategoryViewModel() {
        let categoryViewModel = CategoryViewModel(dataProvider: dataProvider,
                                                  category: newTrackerCategory)
        categoryViewModel.delegate = self
        onShowCategoryView?(categoryViewModel)
    }
    
    func setupScheduleViewModel() {
        let scheduleViewModel = ScheduleViewModel(schedule: newTrackerSchedule)
        scheduleViewModel.delegate = self
        onShowScheduleView?(scheduleViewModel)
    }
}


//Extension

extension NewTrackerViewModel: CategoryViewModelDelegate {
    func didSelectCategory(_ category: String?) {
        newTrackerCategory = category
        isReadyToCreateTracker()
        onSelectCategory?(newTrackerCategory)
    }
    
    func didRecieveCategory(_ category: String?) {
        newTrackerCategory = category
        onChangeCategory?(newTrackerCategory)
    }
}

extension NewTrackerViewModel: ScheduleViewModelDelegate {
    func didRecieveSchedule(_ schedule: Set<WeekDay>) {
        newTrackerSchedule = schedule
        isReadyToCreateTracker()
        onSelectSchedule?(newTrackerSchedule)
    }
}
