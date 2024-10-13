//
//  HabitOrEventViewController.swift
//  Tracker
//
//  Created by Денис Максимов on 06.10.2024.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didRecieveSchedule(_ schedule: Set<WeekDay>)
}

final class NewTrackerViewController: UIViewController {
    
    //MARK: - Init
    
    init(isHabit: Bool) {
        self.isHabit = isHabit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    
    private var newTracker: Tracker?
    private var trackerCategoryIndex: Int?
    private var newTrackerTitle: String?
    private var newTrackerColor: UIColor?
    private var newTrackerEmoji: String?
    private var newTrackerSchedule: Set<WeekDay> = []
    private let isHabit: Bool
    private var categories = TrackerCategoryProvider.shared
    private let emojiCategory: EmojiGategory = EmojiAndColors.emojiCategory
    private let colorsCategory: ColorsGategory = EmojiAndColors.colorsCategory
    private let geomParams = GeometricParams(
        cellCount: 6,
        leftInset: 0,
        rightInset: 0,
        topInset: 24,
        bottomInset: 40,
        cellSpacing: 0)
    private var warningLabelHeightConstraint: NSLayoutConstraint?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = isHabit ? "Новая привычка" :
                               "Новое нерегулярное событие"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    } ()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    } ()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        return contentView
    } ()
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypRed
        return label
    } ()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.leftView = view
        textField.leftViewMode = .always
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = .ypLightGray.withAlphaComponent(0.3)
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        return textField
    } ()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorInset = UIEdgeInsets(
            top: 0,
            left: 16,
            bottom: 0,
            right: 16)
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        return tableView
    } ()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = .clear
        return collection
    } ()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    } ()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.backgroundColor = .ypGray
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return button
    } ()
    
    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    } ()
    
    //MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.reuseIdentifier)
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuseIdentifier)
        collectionView.register(NewTrackerSupplementaryView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: NewTrackerSupplementaryView.identifier)

        setupSubviews()
        addLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let height = collectionView.contentSize.height
        collectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
        
    //MARK: - Methods
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func createButtonTapped() {
        guard let newTracker, let trackerCategoryIndex else { return }
        categories.categoriesProvider.forEach {
            if $0.title == categories.categoriesProvider[trackerCategoryIndex].title {
                var trackers = $0.trackers
                trackers.append(newTracker)
                let newCategory = TrackerCategory(title: $0.title, trackers: trackers)
                categories.categoriesProvider[trackerCategoryIndex] = newCategory
            }
        }
        presentingViewController?.dismiss(animated: true)
    }
    
    private func isReadyToCreateTracker() {
        guard let title = newTrackerTitle,
              let emoji = newTrackerEmoji,
              let color = newTrackerColor,
              let _ = trackerCategoryIndex else { return }
        if isHabit && !newTrackerSchedule.isEmpty {
            newTracker = Tracker(id: categories.lastId + 1,
                                 title: title,
                                 color: color,
                                 emoji: emoji,
                                 schedule: Array(newTrackerSchedule))
            changeCreateButtonState()
        } else if !isHabit {
            newTracker = Tracker(id: categories.lastId + 1,
                                 title: title,
                                 color: color,
                                 emoji: emoji,
                                 schedule: [])
            changeCreateButtonState()
        }
    }
    
    private func changeCreateButtonState() {
        createButton.isEnabled = true
        createButton.backgroundColor = .ypBlack
    }
    
    private func setupSubviews() {
        [titleLabel,scrollView].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        [textField, warningLabel, tableView, collectionView, buttonsStackView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func addOrRemoveWarningLabel(_ isLimited: Bool) {
        
    }
    
    private func addLayout() {
        warningLabelHeightConstraint = warningLabel.heightAnchor.constraint(equalToConstant: .zero)
        warningLabelHeightConstraint?.isActive = true
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            warningLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            warningLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            warningLabel.topAnchor.constraint(equalTo: textField.bottomAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: warningLabel.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: isHabit ? 149 : 74),
            
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 500),
            collectionView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

//
//MARK: - Extensions for UICollectionView
//

extension NewTrackerViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return emojiCategory.emoji.count
        case 1: return colorsCategory.colors.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.reuseIdentifier,
                                                                for: indexPath) as? EmojiCell
            else { return UICollectionViewCell() }
            cell.configureCell(emoji: emojiCategory.emoji[indexPath.row])
            view.layoutIfNeeded()
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reuseIdentifier,
                                                                for: indexPath) as? ColorCell
            else { return UICollectionViewCell() }
            cell.configureCell(color: colorsCategory.colors[indexPath.row])
            view.layoutIfNeeded()
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: NewTrackerSupplementaryView.identifier,
            for: indexPath)
        as? NewTrackerSupplementaryView else {
            return UICollectionReusableView()
        }
        switch indexPath.section {
            case 0:
                headerView.setTitle(emojiCategory.title)
            case 1:
                headerView.setTitle(colorsCategory.title)
            default: break
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
            case 0:
                for row in 0..<collectionView.numberOfItems(inSection: 0) {
                    guard let cell = collectionView.cellForItem(at: IndexPath(item: row, section: 0))
                            as? EmojiCell else { return }
                    cell.cellDidDeselected()
                }
                guard let cell = collectionView.cellForItem(at: indexPath)
                        as? EmojiCell else { return }
                cell.cellDidSelected()
                newTrackerEmoji = emojiCategory.emoji[indexPath.row]
                isReadyToCreateTracker()
            case 1:
                for row in 0..<collectionView.numberOfItems(inSection: 1) {
                    guard let cell = collectionView.cellForItem(at: IndexPath(item: row, section: 1))
                            as? ColorCell else { return }
                    cell.cellDidDeselected()
                }
                guard let cell = collectionView.cellForItem(at: indexPath)
                        as? ColorCell else { return }
                cell.cellDidSelected()
                newTrackerColor = colorsCategory.colors[indexPath.row]
                isReadyToCreateTracker()
            default: break
        }
    }
}

extension NewTrackerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width / CGFloat(geomParams.cellCount)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: geomParams.topInset,
                     left: geomParams.leftInset,
                     bottom: geomParams.bottomInset,
                     right: geomParams.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return geomParams.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView: UICollectionReusableView
        if #available(iOS 18.0, *) {
            return CGSize(width: collectionView.bounds.width - 56, height: 18)
        } else {
            headerView = self.collectionView(collectionView,
                                                 viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
                                                 at: indexPath)
        }
        return headerView.systemLayoutSizeFitting(CGSize(
            width: collectionView.frame.width,
            height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
    }
}

//
//MARK: - Extensions for UITableView
//

extension NewTrackerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = isHabit ? 2 : 1
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.selectionStyle = .none
        cell.backgroundColor = .ypLightGray.withAlphaComponent(0.3)
        cell.accessoryType = .disclosureIndicator
        cell.detailTextLabel?.textColor = .ypGray
        cell.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Категория"
                if let trackerCategoryIndex = trackerCategoryIndex {
                    cell.detailTextLabel?.text = categories.categoriesProvider[trackerCategoryIndex].title
                }
            case 1:
                cell.textLabel?.text = "Расписание"
                cell.detailTextLabel?.text = newTrackerSchedule.count == 7 ?
                                            "Каждый день" :
                                            newTrackerSchedule.compactMap{ $0.short }.joined(separator: ", ")
            default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

extension NewTrackerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let categoryVC = CategoryViewController(delegate: self)
            if let trackerCategoryIndex = trackerCategoryIndex {
                categoryVC.category = categories.categoriesProvider[trackerCategoryIndex].title
            }
            categoryVC.modalPresentationStyle = .popover
            present(categoryVC, animated: true)
        case 1:
            let newScheduleVC = ScheduleViewController(
                delegate: self)
            newScheduleVC.schedule = Set(newTrackerSchedule)
            newScheduleVC.modalPresentationStyle = .popover
            present(newScheduleVC, animated: true)
        default: break
        }
    }
}

//
//MARK: - Extension for ScheduleViewControllerDelegate
//

extension NewTrackerViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text,
              text.count > 0 else {
            return
        }
        newTrackerTitle = text
        isReadyToCreateTracker()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        let isLimited = text.count + string.count <= 38
        warningLabelHeightConstraint?.constant = isLimited ? 0 : 38
        return isLimited
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

//
//MARK: - Extension for ScheduleViewControllerDelegate
//

extension NewTrackerViewController: ScheduleViewControllerDelegate {
    
    func didRecieveSchedule(_ schedule: Set<WeekDay>) {
        newTrackerSchedule = schedule
        tableView.reloadData()
        isReadyToCreateTracker()
    }
}

extension NewTrackerViewController: CategoryViewControllerDelegate {
    
    func didRecieveCategory(_ categoryIndex: Int) {
        trackerCategoryIndex = categoryIndex
        tableView.reloadData()
        isReadyToCreateTracker()
    }
}
