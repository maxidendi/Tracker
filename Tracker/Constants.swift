//
//  Constants.swift
//  Tracker
//
//  Created by Денис Максимов on 28.09.2024.
//

import UIKit

enum Constants {
    enum General {
        static let inset16: CGFloat = 16
        static let inset12: CGFloat = 12
        static let inset4: CGFloat = 4
        static let labelTextHeight: CGFloat = 18
        static let radius8: CGFloat = 8
        static let radius16: CGFloat = 16
        static let stubsSpacing: CGFloat = 8
        static let supplementaryViewHorizontalPadding: CGFloat = 28
        static let itemHeight: CGFloat = 75
        static let separatorInsets: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    enum Typography {
        static let bold34: UIFont = .boldSystemFont(ofSize: 34)
        static let bold32: UIFont = .boldSystemFont(ofSize: 32)
        static let bold19: UIFont = .boldSystemFont(ofSize: 19)
        static let regular17: UIFont = .systemFont(ofSize: 17, weight: .regular)
        static let medium16: UIFont = .systemFont(ofSize: 16, weight: .medium)
        static let medium12: UIFont = .systemFont(ofSize: 12, weight: .medium)
        static let medium10: UIFont = .systemFont(ofSize: 10, weight: .medium)
    }
    enum AlertModelConstants {
        static let actionTitleOk = NSLocalizedString("alert.actionTitleOk", comment: "")
        static let trackersAlertMessage = NSLocalizedString("alert.trackersAlertMessage", comment: "")
        static let addCategoryAlertMessage = NSLocalizedString("alert.addCategoryAlertMessage", comment: "")
        static let chooseCategoryAlertMessage = NSLocalizedString("alert.chooseCategoryAlertMessage", comment: "")
        static let deleteActionTitle = NSLocalizedString("alert.deleteActionTitle", comment: "")
        static let cancelActionTitle = NSLocalizedString("alert.cancelActionTitle", comment: "")
        static let pinActionTitle = NSLocalizedString("alert.pinActionTitle", comment: "")
        static let unpinActionTitle = NSLocalizedString("alert.unpinActionTitle", comment: "")
        static let editActionTitle = NSLocalizedString("alert.editActionTitle", comment: "")
    }
    enum EmojiAndColors {
        static let emojiTitle = NSLocalizedString("emojiAndColors.emojiTitle", comment: "")
        static let colorsTitle = NSLocalizedString("emojiAndColors.colorsTitle", comment: "")
    }
    enum WeekdaySchedule {
        static let monday = NSLocalizedString("weekdaySchedule.monday", comment: "")
        static let tuesday = NSLocalizedString("weekdaySchedule.tuesday", comment: "")
        static let wednesday = NSLocalizedString("weekdaySchedule.wednesday", comment: "")
        static let thursday = NSLocalizedString("weekdaySchedule.thursday", comment: "")
        static let friday = NSLocalizedString("weekdaySchedule.friday", comment: "")
        static let saturday = NSLocalizedString("weekdaySchedule.saturday", comment: "")
        static let sunday = NSLocalizedString("weekdaySchedule.sunday", comment: "")
        static let shortMonday = NSLocalizedString("weekdaySchedule.shortMonday", comment: "")
        static let shortTuesday = NSLocalizedString("weekdaySchedule.shortTuesday", comment: "")
        static let shortWednesday = NSLocalizedString("weekdaySchedule.shortWednesday", comment: "")
        static let shortThursday = NSLocalizedString("weekdaySchedule.shortThursday", comment: "")
        static let shortFriday = NSLocalizedString("weekdaySchedule.shortFriday", comment: "")
        static let shortSaturday = NSLocalizedString("weekdaySchedule.shortSaturday", comment: "")
        static let shortSunday = NSLocalizedString("weekdaySchedule.shortSunday", comment: "")
    }
    enum TrackersViewControllerConstants {
        static let title = NSLocalizedString("trackers.title", comment: "")
        static let searchBarPlaceholder = NSLocalizedString("trackers.searchBarPlaceholder", comment: "")
        static let searchBarCancelButtonTitle = NSLocalizedString("trackers.searchBarCancelButtonTitle", comment: "")
        static let labelStubText = NSLocalizedString("trackers.labelStubText", comment: "")
        static let pinnedCategoryTitle = NSLocalizedString("trackers.pinnedCategoryTitle", comment: "")
        static let geometricParams = GeometricParams(
            cellCount: 2,
            topInset: 8,
            leftInset: 16,
            rightInset: 16,
            bottomInset: 16,
            cellSpacing: 9)
        static let datePickerWidth: CGFloat = 100
        static let collectionViewCellHeight: CGFloat = 148
    }
    enum StatisticViewControllerConstants {
        static let title = NSLocalizedString("statistic.title", comment: "")
        static let labelStubText = NSLocalizedString("statistic.labelStubText", comment: "")
        static let stubsSpacing: CGFloat = 8
    }
    enum TrackerCellConstants {
        static let topViewHeight: CGFloat = 90
        static let bottomViewHeight: CGFloat = 58
        static let emojiAndPinSides: CGFloat = 24
        static let counterButtonDiameter: CGFloat = 34
        static let counterButtonTopInset: CGFloat = 8
        static let insets: UIEdgeInsets = .init(top: 12, left: 12, bottom: 12, right: 12)
    }
    enum NewTrackerViewControllerConstants {
        static let newHabitTitle = NSLocalizedString("newTracker.newHabitTitle", comment: "")
        static let newEventTitle = NSLocalizedString("newTracker.newEventTitle", comment: "")
        static let createHabitTitle = NSLocalizedString("newTracker.createHabitTitle", comment: "")
        static let createEventTitle = NSLocalizedString("newTracker.createEventTitle", comment: "")
        static let warningText = NSLocalizedString("newTracker.warningText", comment: "")
        static let placeholderText = NSLocalizedString("newTracker.placeholderText", comment: "")
        static let cancelButtonTitle = NSLocalizedString("newTracker.cancelButtonTitle", comment: "")
        static let createButtonTitle = NSLocalizedString("newTracker.createButtonTitle", comment: "")
        static let categoryTitle = NSLocalizedString("newTracker.categoryTitle", comment: "")
        static let scheduleTitle = NSLocalizedString("newTracker.scheduleTitle", comment: "")
        static let scheduleEverydayTitle = NSLocalizedString("newTracker.scheduleEverydayTitle", comment: "")
        static let geometricParams = GeometricParams(
            cellCount: 6,
            topInset: 24,
            leftInset: 0,
            rightInset: 0,
            bottomInset: 40,
            cellSpacing: 0)
        static let textFieldCharacterLimit: Int = 38
        static let warningLabelHeight: CGFloat = 38
        static let buttonsSpacing: CGFloat = 8
        static let titleHeigth: CGFloat = 50
        static let titleTopInset: CGFloat = 14
        static let buttonHeight: CGFloat = 60
        static let buttonsStackHorizontalPadding: CGFloat = 20
        static let collectionViewTopInset: CGFloat = 32
        static let buttonsStackVerticalPadding: CGFloat = 24
        static let colorCellBorderWidth: CGFloat = 3
    }
    enum HabitOrEventViewControllerConstants {
        static let habitButtonTitle = NSLocalizedString("habitOrEvent.habitButtonTitle", comment: "")
        static let eventButtonTitle = NSLocalizedString("habitOrEvent.eventButtonTitle", comment: "")
        static let title = NSLocalizedString("habitOrEvent.title", comment: "")
        static let titleHeigth: CGFloat = 50
        static let titleTopInset: CGFloat = 14
        static let buttonHeight: CGFloat = 60
        static let buttonsStackHorizontalPadding: CGFloat = 20
        static let buttonsSpacing: CGFloat = 16
        static let stackViewYInset: CGFloat = 32
    }
    enum CategoryViewControllerConstants {
        static let title = NSLocalizedString("category.title", comment: "")
        static let labelStubText = NSLocalizedString("category.labelStubText", comment: "")
        static let addCategoryButtonTitle = NSLocalizedString("category.addCategoryButtonTitle", comment: "")
        static let titleHeigth: CGFloat = 50
        static let titleTopInset: CGFloat = 14
        static let buttonHeight: CGFloat = 60
        static let buttonHorizontalPadding: CGFloat = 20
        static let verticalSpacing: CGFloat = 24
    }
    enum AddCategoryViewControllerConstants {
        static let addTitle = NSLocalizedString("addCategory.addTitle", comment: "")
        static let editTitle = NSLocalizedString("addCategory.editTitle", comment: "")
        static let textFieldPlaceholderText = NSLocalizedString("addCategory.textFieldPlaceholderText", comment: "")
        static let doneButtonTitle = NSLocalizedString("addCategory.doneButtonTitle", comment: "")
        static let titleHeigth: CGFloat = 50
        static let titleTopInset: CGFloat = 14
        static let buttonHeight: CGFloat = 60
        static let buttonHorizontalPadding: CGFloat = 20
        static let verticalSpacing: CGFloat = 24
    }
    enum ScheduleViewControllerConstants {
        static let title = NSLocalizedString("schedule.title", comment: "")
        static let doneButtonTitle = NSLocalizedString("schedule.doneButtonTitle", comment: "")
        static let titleHeigth: CGFloat = 50
        static let titleTopInset: CGFloat = 14
        static let buttonHeight: CGFloat = 60
        static let buttonHorizontalPadding: CGFloat = 20
        static let verticalSpacing: CGFloat = 24
    }
}
