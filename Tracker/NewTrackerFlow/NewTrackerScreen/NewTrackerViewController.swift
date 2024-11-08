//
//  HabitOrEventViewController.swift
//  Tracker
//
//  Created by Денис Максимов on 06.10.2024.
//

import UIKit

final class NewTrackerViewController: UIViewController {
    
    //MARK: - Init
    
    init(isHabit: Bool, dataProvider: DataProviderProtocol) {
        self.isHabit = isHabit
        self.dataProvider = dataProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    
    weak var delegate: NewCategoryViewControllerDelegate?
    private let constants = Constants.NewTrackerViewControllerConstants.self
    private var newTracker: Tracker?
    private var trackerCategory: String?
    private var newTrackerTitle: String?
    private var newTrackerColor: UIColor?
    private var newTrackerEmoji: String?
    private var newTrackerSchedule: Set<WeekDay> = []
    private let isHabit: Bool
    private let dataProvider: DataProviderProtocol
    private let emojiCategory: EmojiGategory = EmojiAndColors.emojiCategory
    private let colorsCategory: ColorsGategory = EmojiAndColors.colorsCategory
    private var selectedEmojiIndexPath: IndexPath?
    private var selectedColorIndexPath: IndexPath?
    private var warningLabelHeightConstraint: NSLayoutConstraint?
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = isHabit ? constants.newHabitTitle :
                               constants.newEventTitle
        label.textAlignment = .center
        label.font = Constants.Typography.medium16
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
        label.text = constants.warningText
        label.textAlignment = .center
        label.font = Constants.Typography.regular17
        label.textColor = .ypRed
        return label
    } ()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        let view = UIView(frame: CGRect(x: .zero, y: .zero,
                                        width: Constants.General.inset16,
                                        height: Constants.General.itemHeight))
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.leftView = view
        textField.leftViewMode = .always
        textField.placeholder = constants.placeholderText
        textField.backgroundColor = .ypLightGray.withAlphaComponent(0.3)
        textField.font = Constants.Typography.regular17
        textField.layer.cornerRadius = Constants.General.radius16
        textField.layer.masksToBounds = true
        return textField
    } ()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorColor = .ypGray
        tableView.separatorInset = UIEdgeInsets(
            top: .zero,
            left: Constants.General.inset16,
            bottom: .zero,
            right: Constants.General.inset16)
        tableView.layer.cornerRadius = Constants.General.radius16
        tableView.layer.masksToBounds = true
        return tableView
    } ()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = .clear
        return collection
    } ()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(constants.cancelButtonTitle, for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.titleLabel?.font = Constants.Typography.medium16
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = Constants.General.radius16
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    } ()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(constants.createButtonTitle, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.backgroundColor = .ypGray
        button.titleLabel?.font = Constants.Typography.medium16
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = Constants.General.radius16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return button
    } ()
    
    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = constants.buttonsSpacing
        return stack
    } ()
    
    //MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        addSubviews()
        layoutSubviews()
        setupToHideKeyboard()
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let height = collectionView.contentSize.height
        collectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
        
    //MARK: - Methods
    
    @objc func cancelButtonTapped() {
        delegate?.dismissNewTrackerFlow()
    }
    
    @objc func createButtonTapped() {
        guard let newTracker, let trackerCategory else { return }
        delegate?.dismissNewTrackerFlow()
        dataProvider.addTracker(newTracker, to: trackerCategory)
    }
    
    private func isReadyToCreateTracker() {
        guard let title = newTrackerTitle,
              !title.isEmpty,
              let emoji = newTrackerEmoji,
              let color = newTrackerColor,
              let _ = trackerCategory
        else {
            changeCreateButtonState(false)
            return
        }
        if isHabit && !newTrackerSchedule.isEmpty {
            newTracker = Tracker(id: UUID(),
                                 title: title,
                                 color: color,
                                 emoji: emoji,
                                 schedule: Array(newTrackerSchedule))
            changeCreateButtonState(true)
        } else if !isHabit {
            newTracker = Tracker(id: UUID(),
                                 title: title,
                                 color: color,
                                 emoji: emoji,
                                 schedule: [])
            changeCreateButtonState(true)
        }
    }
    
    private func changeCreateButtonState(_ isEnabled: Bool) {
        createButton.isEnabled = isEnabled
        createButton.backgroundColor = isEnabled ? .ypBlack : .ypGray
    }
}

//
//MARK: - SetupSubviewsProtocol extension
//

extension NewTrackerViewController: SetupSubviewsProtocol {
    
    func addSubviews() {
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
    
    func layoutSubviews() {
        warningLabelHeightConstraint = warningLabel.heightAnchor.constraint(equalToConstant: .zero)
        warningLabelHeightConstraint?.isActive = true
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: constants.titleTopInset),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: constants.titleHeigth),
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: Constants.General.inset16),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -Constants.General.inset16),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor,
                                           constant: constants.geometricParams.topInset),
            textField.heightAnchor.constraint(equalToConstant: Constants.General.itemHeight),
            warningLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                  constant: Constants.General.inset16),
            warningLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                   constant: -Constants.General.inset16),
            warningLabel.topAnchor.constraint(equalTo: textField.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: Constants.General.inset16),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -Constants.General.inset16),
            tableView.topAnchor.constraint(equalTo: warningLabel.bottomAnchor,
                                           constant: constants.geometricParams.topInset),
            tableView.heightAnchor.constraint(equalToConstant: isHabit ? Constants.General.itemHeight * 2 - 1 :
                                                                         Constants.General.itemHeight - 1),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                    constant: Constants.General.inset16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                     constant: -Constants.General.inset16),
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor,
                                                constant: constants.collectionViewTopInset),
            collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 500),
            collectionView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor),
            buttonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                      constant: constants.buttonsStackHorizontalPadding),
            buttonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                       constant: -constants.buttonsStackHorizontalPadding),
            buttonsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                     constant: -constants.buttonsStackVerticalPadding),
            buttonsStackView.heightAnchor.constraint(equalToConstant: constants.buttonHeight)
        ])
    }
}

//
//MARK: - UICollectionView extensions
//

extension NewTrackerViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return emojiCategory.emoji.count
        case 1: return colorsCategory.colors.count
        default: return .zero
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
                if let selectedEmojiIndexPath,
                   let oldCell = collectionView.cellForItem(at: selectedEmojiIndexPath) as? EmojiCell
                {
                    oldCell.cellDidDeselected()
                }
                selectedEmojiIndexPath = indexPath
                guard let newCell = collectionView.cellForItem(at: indexPath) as? EmojiCell
                else { return }
                newCell.cellDidSelected()
                newTrackerEmoji = emojiCategory.emoji[indexPath.row]
                isReadyToCreateTracker()
            case 1:
                if let selectedColorIndexPath,
                   let oldCell = collectionView.cellForItem(at: selectedColorIndexPath) as? ColorCell
                {
                    oldCell.cellDidDeselected()
                }
                selectedColorIndexPath = indexPath
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
        let cellWidth = collectionView.bounds.width / CGFloat(constants.geometricParams.cellCount)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: constants.geometricParams.topInset,
                     left: constants.geometricParams.leftInset,
                     bottom: constants.geometricParams.bottomInset,
                     right: constants.geometricParams.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return constants.geometricParams.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView: UICollectionReusableView
        if #available(iOS 18.0, *) {
            return CGSize(width: collectionView.bounds.width - Constants.General.supplementaryViewHorizontalPadding * 2,
                          height: Constants.General.labelTextHeight)
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
//MARK: - UITableView extensions
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
        cell.detailTextLabel?.font = Constants.Typography.regular17
        switch indexPath.row {
            case 0:
                cell.textLabel?.text = constants.categoryTitle
                if let trackerCategory {
                    cell.detailTextLabel?.text = trackerCategory
                }
            case 1:
                cell.textLabel?.text = constants.scheduleTitle
            cell.detailTextLabel?.text = newTrackerSchedule.count == WeekDay.allCases.count ?
                                            constants.scheduleEverydayTitle :
                                            newTrackerSchedule.compactMap{ $0.short }.joined(separator: ", ")
            default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.General.itemHeight
    }
}

extension NewTrackerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let categoryViewModel = CategoryViewModel(dataProvider: dataProvider)
            let categoryVC = CategoryView(viewModel: categoryViewModel,
                                          category: trackerCategory,
                                          delegate: self)
            categoryVC.modalPresentationStyle = .popover
            present(categoryVC, animated: true)
        case 1:
            let newScheduleVC = ScheduleViewController(delegate: self,
                                                       schedule: newTrackerSchedule)
            newScheduleVC.modalPresentationStyle = .popover
            present(newScheduleVC, animated: true)
        default: break
        }
    }
}

//
//MARK: - UITextField extension
//

extension NewTrackerViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        newTrackerTitle = textField.text
        isReadyToCreateTracker()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        let isLimited = text.count + string.count <= constants.textFieldCharacterLimit
        warningLabelHeightConstraint?.constant = isLimited ? .zero : constants.warningLabelHeight
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.warningLabelHeightConstraint?.constant = .zero
        }
        return isLimited
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

//
//MARK: - Delegate extensions
//

extension NewTrackerViewController: ScheduleViewControllerDelegate {
    
    func didRecieveSchedule(_ schedule: Set<WeekDay>) {
        newTrackerSchedule = schedule
        tableView.reloadData()
        isReadyToCreateTracker()
    }
}

extension NewTrackerViewController: CategoryViewControllerDelegate {
    
    func didRecieveCategory(_ category: String) {
        trackerCategory = category
        tableView.reloadData()
        isReadyToCreateTracker()
    }
}
