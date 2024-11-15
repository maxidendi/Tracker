//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Денис Максимов on 27.09.2024.
//

import UIKit

final class TrackersView: UIViewController {
    
    //MARK: - Init
    
    init(viewModel: TrackersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    
    private let viewModel: TrackersViewModelProtocol
    private let constants = Constants.TrackersViewControllerConstants.self
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.register(TrackerCell.self,
                            forCellWithReuseIdentifier: TrackerCell.reuseIdentifier)
        collection.register(TrackersSupplementaryView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: TrackersSupplementaryView.identifier)
        return collection
    } ()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.locale = .autoupdatingCurrent
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
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
        return imageView
    } ()
    
    private lazy var labelStub: UILabel = {
        let label = UILabel()
        label.text = constants.labelStubText
        label.font = Constants.Typography.medium12
        label.textAlignment = .center
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
        bind()
        setupToHideKeyboard()
        addSubviews()
        layoutSubviews()
        setupNavigationBar()
        datePickerValueChanged()
    }
    
    //MARK: - Methods
    
    private func bind() {
        viewModel.onUpdateTrackers = { [weak self] indexes in
            self?.collectionView.performBatchUpdates{
                self?.collectionView.insertSections(indexes.insertedSections)
                self?.collectionView.deleteSections(indexes.deletedSections)
                self?.collectionView.insertItems(at: Array(indexes.insertedIndexes))
                self?.collectionView.deleteItems(at: Array(indexes.deletedIndexes))
                self?.collectionView.reloadItems(at: Array(indexes.updatedIndexes))
            }
        }
    }
    
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
    
    private func stubsIsHidden(_ isHidden: Bool) {
        labelStub.isHidden = isHidden
        imageStubView.isHidden = isHidden
    }
    
    //MARK: - Objc methods
    
    @objc private func datePickerValueChanged() {
        viewModel.updateTrackers(for: datePicker.date)
        collectionView.reloadData()
        dismiss(animated: true)
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

extension TrackersView: SetupSubviewsProtocol {
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

extension TrackersView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let numberOfSection = viewModel.numberOfcategories() ?? 0
        numberOfSection == 0 ? stubsIsHidden(false) : stubsIsHidden(true)
        return numberOfSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfTrackers(for: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackersSupplementaryView.identifier,
            for: indexPath)
        as? TrackersSupplementaryView else {
            return UICollectionReusableView()
        }
        headerView.setTitle(viewModel.titleForCategory(indexPath.section) ?? "")
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCell.reuseIdentifier,
            for: indexPath) as? TrackerCell,
              let trackerCellModel = viewModel.getTrackerCellModel(at: indexPath)
        else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        cell.configureCell(model: trackerCellModel)
        return cell
    }
    
    //Available context menu and preview for iOS 16.0 and higher
    @available(iOS 16.0, *)
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
        let alertModel = AlertModel(message: Constants.AlertModelConstants.trackersAlertMessage,
                                    actionTitle: Constants.AlertModelConstants.deleteActionTitle)
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil
        ) { [weak self] _ in
            let deleteAction = UIAction(
                title: Constants.AlertModelConstants.deleteActionTitle,
                image: nil,
                attributes: .destructive
            ) { _ in
                self?.showAlertWithCancel(
                    with: alertModel,
                    alertStyle: .actionSheet,
                    actionStyle: .destructive
                ) { _ in
                    self?.viewModel.deleteTracker(indexPath)
                }
            }
            return UIMenu(title: "", children: [deleteAction])
        }
    }
    
    @available(iOS 16.0, *)
    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell else { return nil }
        let preview = UITargetedPreview(view: cell.topViewForPreview())
        return preview
    }
    
    @available(iOS 16.0, *)
    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, dismissalPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell else { return nil }
        let preview = UITargetedPreview(view: cell.topViewForPreview())
        return preview
    }
    
    //Available context menu and preview for iOS 13.4 - 16.0
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let alertModel = AlertModel(message: Constants.AlertModelConstants.trackersAlertMessage,
                                    actionTitle: Constants.AlertModelConstants.deleteActionTitle)
        return UIContextMenuConfiguration(
            identifier: indexPath as NSCopying,
            previewProvider: nil
        ) { [weak self] _ in
            let deleteAction = UIAction(
                title: Constants.AlertModelConstants.deleteActionTitle,
                image: nil,
                attributes: .destructive
            ) { _ in
                self?.showAlertWithCancel(
                    with: alertModel,
                    alertStyle: .actionSheet,
                    actionStyle: .destructive
                ) { _ in
                    self?.viewModel.deleteTracker(indexPath)
                }
            }
            return UIMenu(title: "", children: [deleteAction])
        }
    }

    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell else { return nil }
        let preview = UITargetedPreview(view: cell.topViewForPreview())
        return preview
    }
    
    func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell else { return nil }
        let preview = UITargetedPreview(view: cell.topViewForPreview())
        return preview
    }
}

extension TrackersView: UICollectionViewDelegateFlowLayout {
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
                          height: Constants.General.labelTextHeight + 2)
        } else {
            headerView = self.collectionView(collectionView,
                                             viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
                                             at: indexPath)
        }
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
}

//
//MARK: - Delegates extensions
//

extension TrackersView: TrackerCellDelegate {
    func counterButtonTapped(with id: UUID, isCompleted: Bool) {
        viewModel.trackerRecordChanged(id, isCompleted: isCompleted)
    }
}

extension TrackersView: HabitOrEventViewControllerDelegate {
    func getDataProvider() -> DataProviderProtocol {
        viewModel.getDataProvider()
    }
    
    func needToReloadCollectionView() {
        dismiss(animated: true)
    }
}
