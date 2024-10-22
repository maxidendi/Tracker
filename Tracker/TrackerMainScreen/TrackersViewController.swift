//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Денис Максимов on 27.09.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    //MARK: - Properties
    
    private var visibleCategories: [TrackerCategory] = []
    private var categories = TrackerCategoryProvider.shared
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate = Date()
    private let calendar = Calendar.current
    private let constants = Constants.TrackersViewControllerConstants.self
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    } ()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.locale = .init(identifier: "ru_RU")
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return picker
    } ()
    
    private lazy var searchBarController: UISearchController = {
        let searchBarController = UISearchController(searchResultsController: nil)
        searchBarController.searchBar.setValue(constants.searchBarCancelButtonTitle,
                                               forKey: "cancelButtonText")
        searchBarController.searchBar.placeholder = constants.searchBarPlaceholder
        searchBarController.hidesNavigationBarDuringPresentation = false
        searchBarController.searchBar.searchTextField.clearButtonMode = .never
        return searchBarController
    } ()
    
    private lazy var imageStubView: UIImageView = {
        let imageView = UIImageView(image: .trackersImageStub)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    private lazy var labelStub: UILabel = {
        let label = UILabel()
        label.text = constants.labelStubText
        label.font = Constants.Typography.medium12
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private lazy var tabBarSeparatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = .ypGray
        return separator
    } ()
    
    //MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        addSubviews()
        layoutSubviews()
        setupNavigationBar()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.reuseIdentifier)
        collectionView.register(TrackersSupplementaryView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TrackersSupplementaryView.identifier)
        datePickerValueChanged(datePicker)
    }
    
    //MARK: - Methods
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = constants.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .trackersPlusItem,
            style: .plain,
            target: self,
            action: #selector(didTapPlusButton))
        navigationItem.leftBarButtonItem?.tintColor = .ypBlack
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.searchController = searchBarController
    }
    
    private func showStubsOrTrackers() {
        collectionView.reloadData()
        let isEmpty = visibleCategories.isEmpty
        labelStub.isHidden = !isEmpty
        imageStubView.isHidden = !isEmpty
    }
    
    //MARK: - Objc methods
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = calendar.onlyDate(from: sender.date)
        let weekDay = calendar.component(.weekday, from: currentDate)
        var visibleCategories: [TrackerCategory] = []
        categories.categoriesProvider.forEach { category in
            var trackers: [Tracker] = []
            category.trackers.forEach { tracker in
                guard tracker.schedule.isEmpty,
                      !completedTrackers.contains(where: {
                          $0.id == tracker.id &&
                          $0.date != currentDate})
                else {
                    tracker.schedule.forEach { schedule in
                        if schedule.toInt == weekDay {
                            trackers.append(tracker)
                        }
                    }
                    return
                }
                trackers.append(tracker)
            }
            let visibleCategory: TrackerCategory = TrackerCategory(title: category.title, trackers: trackers)
            if !visibleCategory.trackers.isEmpty {
                visibleCategories.append(visibleCategory)
            }
        }
        self.visibleCategories = visibleCategories
        showStubsOrTrackers()
    }
    
    @objc private func didTapPlusButton() {
        let createTrackerViewController = HabitOrEventViewController()
        createTrackerViewController.delegate = self
        createTrackerViewController.modalPresentationStyle = .popover
        present(createTrackerViewController, animated: true, completion: nil)
    }
}

//
//MARK: - SetupSubviewsProtocol extension
//

extension TrackersViewController: SetupSubviewsProtocol {
    
    func addSubviews() {
        [imageStubView, labelStub, collectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false }
        tabBarController?.tabBar.addSubview(tabBarSeparatorView)
        tabBarSeparatorView.frame = CGRect(x: .zero, y: .zero, width: view.frame.width, height: 1)
    }

    func layoutSubviews() {
        NSLayoutConstraint.activate([
            imageStubView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageStubView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            labelStub.heightAnchor.constraint(equalToConstant: Constants.General.labelTextHeight),
            labelStub.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                               constant: constants.geometricParams.leftInset),
            labelStub.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                constant: -constants.geometricParams.rightInset),
            labelStub.topAnchor.constraint(equalTo: imageStubView.bottomAnchor,
                                           constant: Constants.General.stubsSpacing),
            datePicker.widthAnchor.constraint(equalToConstant: constants.datePickerWidth),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                constant: Constants.General.inset16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

//
//MARK: - UICollectionView extensions
//

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackersSupplementaryView.identifier,
            for: indexPath)
        as? TrackersSupplementaryView else {
            return UICollectionReusableView()
        }
        headerView.setTitle(visibleCategories[indexPath.section].title)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCell.reuseIdentifier,
            for: indexPath) as? TrackerCell
        else {
            return UICollectionViewCell()
        }
        let isCompleted = completedTrackers.contains(where: {
            $0.id == visibleCategories[section].trackers[indexPath.row].id &&
            calendar.numberOfDaysBetween($0.date, and: currentDate) == 0
        })
        let counter = completedTrackers.filter({$0.id == visibleCategories[section].trackers[indexPath.row].id}).count
        cell.delegate = self
        cell.configureCell(id: visibleCategories[section].trackers[indexPath.row].id,
                           title: visibleCategories[section].trackers[indexPath.row].title,
                           emoji: visibleCategories[section].trackers[indexPath.row].emoji,
                           color: visibleCategories[section].trackers[indexPath.row].color,
                           counter: counter,
                           isCompleted: isCompleted)
        return cell
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width - constants.geometricParams.paddingWidth
        let itemWidth = availableWidth / CGFloat(constants.geometricParams.cellCount)
        return CGSize(width: itemWidth, height: constants.collectionViewCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: constants.geometricParams.topInset,
                     left: constants.geometricParams.leftInset,
                     bottom: constants.geometricParams.bottomInset,
                     right: constants.geometricParams.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        constants.geometricParams.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: .zero, section: section)
        let headerView: UICollectionReusableView
        if #available(iOS 18.0, *) {
            return CGSize(width: collectionView.bounds.width - 2 * Constants.General.supplementaryViewHorizontalPadding,
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
//MARK: - Delegates extensions
//

extension TrackersViewController: TrackerCellDelegate {
    
    func counterButtonTapped(with id: UUID, isCompleted: Bool, completion: @escaping () -> Void) {
        let trackerRecord = TrackerRecord(id: id, date: currentDate)
        if isCompleted {
            guard let numberOfDays = calendar.numberOfDaysBetween(currentDate),
                  numberOfDays >= .zero
            else { return }
            completedTrackers.insert(trackerRecord)
            completion()
        } else {
            completedTrackers.remove(trackerRecord)
            completion()
        }
    }
}

extension TrackersViewController: HabitOrEventViewControllerDelegate {
    
    func needToReloadCollectionView() {
        dismiss(animated: true)
        datePickerValueChanged(datePicker)
    }
}
