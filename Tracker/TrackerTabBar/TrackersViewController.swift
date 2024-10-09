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
    private var categories: [TrackerCategory] = MockTrackersCategory.shared
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate = Date()
    private let geomParams = GeometricParams(
        cellCount: 2,
        leftInset: 16,
        rightInset: 16,
        topInset: 8,
        bottomInset: 16,
        cellSpacing: 9)
    
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
        searchBarController.searchBar.setValue("Отменить", forKey: "cancelButtonText")
        searchBarController.searchBar.placeholder = "Поиск"
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
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private lazy var tabBarSeparatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = .ypBackground
        return separator
    } ()
    
    //MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        addSubviews()
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
    
    private func addSubviews() {
        [imageStubView, labelStub, collectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false }
        tabBarController?.tabBar.addSubview(tabBarSeparatorView)
        tabBarSeparatorView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 1)
        NSLayoutConstraint.activate([
            imageStubView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageStubView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            labelStub.heightAnchor.constraint(equalToConstant: 18),
            labelStub.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            labelStub.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            labelStub.topAnchor.constraint(equalTo: imageStubView.bottomAnchor, constant: 8),
            datePicker.widthAnchor.constraint(equalToConstant: 100),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Трекеры"
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
        if visibleCategories.isEmpty {
            labelStub.isHidden = false
            imageStubView.isHidden = false
        } else {
            labelStub.isHidden = true
            imageStubView.isHidden = true
        }
    }
    
    //MARK: - Objc methods
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        let weekDay = Calendar.current.component(.weekday, from: currentDate)
        var visibleCategories: [TrackerCategory] = []
        categories.forEach { category in
            var visibleCategory: TrackerCategory = TrackerCategory(title: category.title, trackers: [])
            category.trackers.forEach { tracker in
                tracker.schedule.forEach { schedule in
                    if schedule.toInt == weekDay {
                        visibleCategory.trackers.append(tracker)
                    }
                }
            }
            if !visibleCategory.trackers.isEmpty {
                visibleCategories.append(visibleCategory)
            }
        }
        self.visibleCategories = visibleCategories
        sender.isSelected = false
        showStubsOrTrackers()
    }
    
    @objc private func didTapPlusButton() {
        let createTrackerViewController = CreateTrackerViewController()
        createTrackerViewController.modalPresentationStyle = .popover
        present(createTrackerViewController, animated: true, completion: nil)
    }
}

//MARK: - Extensions

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
            $0.date == currentDate})
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
        let availableWidth = collectionView.bounds.width - geomParams.paddingWidth
        let itemWidth = availableWidth / CGFloat(geomParams.cellCount)
        return CGSize(width: itemWidth, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: geomParams.topInset,
                     left: geomParams.leftInset,
                     bottom: geomParams.bottomInset,
                     right: geomParams.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        geomParams.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView,
                                             viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
                                             at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(
            width: collectionView.frame.width,
            height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
    }
}

extension TrackersViewController: TrackerCellDelegate {
    
    func counterButtonTapped(with id: UInt, isCompleted: Bool, completion: @escaping () -> Void) {
        let trackerRecord = TrackerRecord(id: id, date: currentDate)
        if isCompleted {
            guard let numberOfDays = Calendar.current.numberOfDaysBetween(currentDate),
                  numberOfDays >= 0
            else {
                return
            }
            completedTrackers.insert(trackerRecord)
            completion()
        } else {
            completedTrackers.remove(trackerRecord)
            completion()
        }
    }
}
