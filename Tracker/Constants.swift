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
        static let actionTitleAddCategory = "Ok"
        static let messageAddCategory = "Категория с таким наименованием уже существует"
    }
    enum TrackersViewControllerConstants {
        static let title = "Трекеры"
        static let geometricParams = GeometricParams(
            cellCount: 2,
            topInset: 8,
            leftInset: 16,
            rightInset: 16,
            bottomInset: 16,
            cellSpacing: 9)
        static let searchBarPlaceholder = "Поиск"
        static let searchBarCancelButtonTitle = "Отменить"
        static let labelStubText = "Что будем отслеживать?"
        static let datePickerWidth: CGFloat = 100
        static let collectionViewCellHeight: CGFloat = 148
    }
    enum StatisticViewControllerConstants {
        static let title = "Статистика"
        static let labelStubText = "Анализировать пока нечего?"
        static let stubsSpacing: CGFloat = 8
    }
    enum TrackerCellConstants {
        static let topViewHeight: CGFloat = 90
        static let bottomViewHeight: CGFloat = 58
        static let emojiLabelDiameter: CGFloat = 24
        static let counterButtonDiameter: CGFloat = 34
        static let counterButtonTopInset: CGFloat = 8
        static let insets: UIEdgeInsets = .init(top: 12, left: 12, bottom: 12, right: 12)
    }
    enum NewTrackerViewControllerConstants {
        static let geometricParams = GeometricParams(
            cellCount: 6,
            topInset: 24,
            leftInset: 0,
            rightInset: 0,
            bottomInset: 40,
            cellSpacing: 0)
        static let newHabitTitle = "Новая привычка"
        static let newEventTitle = "Новое нерегулярное событие"
        static let warningText = "Ограничение 38 символов"
        static let placeholderText = "Введите название трекера"
        static let cancelButtonTitle = "Отменить"
        static let createButtonTitle = "Создать"
        static let categoryTitle = "Категория"
        static let scheduleTitle = "Расписание"
        static let scheduleEverydayTitle = "Каждый день"
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
        static let habitButtonTitle = "Привычка"
        static let eventButtonTitle = "Нерегулярное событие"
        static let title = "Создание трекера"
        static let titleHeigth: CGFloat = 50
        static let titleTopInset: CGFloat = 14
        static let buttonHeight: CGFloat = 60
        static let buttonsStackHorizontalPadding: CGFloat = 20
        static let buttonsSpacing: CGFloat = 16
        static let stackViewYInset: CGFloat = 32
    }
    enum CategoryViewControllerConstants {
        static let title = "Категория"
        static let labelStubText = "Привычки и события можно \nобъединить по смыслу"
        static let addCategoryButtonTitle = "Добавить категорию"
        static let titleHeigth: CGFloat = 50
        static let titleTopInset: CGFloat = 14
        static let buttonHeight: CGFloat = 60
        static let buttonHorizontalPadding: CGFloat = 20
        static let verticalSpacing: CGFloat = 24
    }
    enum AddCategoryViewControllerConstants {
        static let title = "Новая категория"
        static let textFieldPlaceholderText = "Введите название категории"
        static let doneButtonTitle = "Готово"
        static let titleHeigth: CGFloat = 50
        static let titleTopInset: CGFloat = 14
        static let buttonHeight: CGFloat = 60
        static let buttonHorizontalPadding: CGFloat = 20
        static let verticalSpacing: CGFloat = 24
    }
    enum ScheduleViewControllerConstants {
        static let title = "Расписание"
        static let doneButtonTitle = "Готово"
        static let titleHeigth: CGFloat = 50
        static let titleTopInset: CGFloat = 14
        static let buttonHeight: CGFloat = 60
        static let buttonHorizontalPadding: CGFloat = 20
        static let verticalSpacing: CGFloat = 24
    }
}
