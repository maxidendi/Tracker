//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Денис Максимов on 09.10.2024.
//

import UIKit

final class CategoryView: UIViewController {
    
    //MARK: - Init
    
    init(viewModel: CategoryViewModelProtocol,
         delegate: CategoryViewControllerDelegate? = nil
    ) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    
    weak var delegate: CategoryViewControllerDelegate?
    private var viewModel: CategoryViewModelProtocol
    private let constants = Constants.CategoryViewControllerConstants.self
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.alpha = 0
        visualEffectView.frame = view.bounds
        return visualEffectView
    } ()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = constants.title
        label.textAlignment = .center
        label.font = Constants.Typography.medium16
        return label
    } ()
    
    private lazy var imageStubView: UIImageView = {
        let imageView = UIImageView(image: .trackersImageStub)
        return imageView
    } ()
    
    private lazy var labelStub: UILabel = {
        let label = UILabel()
        label.text = constants.labelStubText
        label.font = Constants.Typography.medium12
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    } ()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .ypWhite
        tableView.separatorColor = .ypGray
        tableView.isScrollEnabled = true
        tableView.clipsToBounds = false
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identifier)
        return tableView
    } ()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(constants.addCategoryButtonTitle, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.backgroundColor = .ypBlack
        button.titleLabel?.font = Constants.Typography.medium16
        button.layer.cornerRadius = Constants.General.radius16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        return button
    } ()

    
    //MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        addSubviews()
        layoutSubviews()
        bind()
    }
    
    //MARK: - Methods
    
    private func bind() {
        viewModel.onCategoriesListStateChange = { [weak self] indexes in
            self?.updateTableView(with: indexes)
        }
        viewModel.onCategorySelected = { [weak self] category in
            self?.delegate?.didSelectCategory(category)
        }
        viewModel.onCategoryChanged = { [weak self] category in
            self?.delegate?.didRecieveCategory(category)
        }
    }
    
    private func updateTableView(with indexes: CategoryIndexes) {
        tableView.performBatchUpdates({
            tableView.insertRows(at: Array(indexes.insertedIndexes), with: .automatic)
            tableView.deleteRows(at: Array(indexes.deletedIndexes), with: .automatic)
            tableView.reloadRows(at: Array(indexes.updatedIndexes), with: .automatic)
        }, completion: { [weak self] _ in
            self?.configureCells()
        })
    }
    
    private func configureCells() {
        let rows = viewModel.categoriesList().count
        for row in 0..<rows {
            let indexPath = IndexPath(row: row, section: 0)
            let cell = tableView.cellForRow(at: indexPath)
            cell?.setSeparatorAndCorners(rows: rows, indexPath: indexPath)
        }
    }
    
    private func showStubsOrCategories(_ rows: Int) {
        let isEmpty = rows == 0
        labelStub.isHidden = !isEmpty
        imageStubView.isHidden = !isEmpty
    }
    
    @objc private func addCategoryButtonTapped() {
        let addCategoryViewController = AddCategoryViewController(dataProvider: viewModel.getDataProvider(),
                                                                  delegate: self)
        addCategoryViewController.modalPresentationStyle = .popover
        present(addCategoryViewController, animated: true)
    }
}

//MARK: - Extensions

extension CategoryView: SetupSubviewsProtocol {
    
    func addSubviews() {
        [titleLabel, tableView, addCategoryButton, imageStubView, labelStub, blurEffectView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func layoutSubviews() {
        NSLayoutConstraint.activate([
            imageStubView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageStubView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            labelStub.heightAnchor.constraint(equalToConstant: Constants.General.labelTextHeight * 2),
            labelStub.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                               constant: Constants.General.inset16),
            labelStub.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                constant: -Constants.General.inset16),
            labelStub.topAnchor.constraint(equalTo: imageStubView.bottomAnchor,
                                           constant: Constants.General.stubsSpacing),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: constants.titleTopInset),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: constants.titleHeigth),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                               constant: Constants.General.inset16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                constant: -Constants.General.inset16),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                           constant: constants.verticalSpacing),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor,
                                              constant: -constants.verticalSpacing),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                       constant: constants.buttonHorizontalPadding),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                        constant: -constants.buttonHorizontalPadding),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                      constant: -constants.verticalSpacing),
            addCategoryButton.heightAnchor.constraint(equalToConstant: constants.buttonHeight)
        ])
    }
}

extension CategoryView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = viewModel.categoriesList().count
        showStubsOrCategories(numberOfRows)
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryCell.identifier,
            for: indexPath) as? CategoryCell
        else { return UITableViewCell() }
        let categories = viewModel.categoriesList()
        let isMarked = viewModel.isCellMarked(at: indexPath)
        cell.configure(category: categories[indexPath.row],
                       isMarked: isMarked,
                       indexPath: indexPath,
                       rowsCount: categories.count)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.General.itemHeight
    }
}

extension CategoryView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt
                   indexPath: IndexPath,
                   point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let alertModel = AlertModel(message: "Эта категория точно не нужна?",
                                    actionTitle: "Удалить")
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil
        ) { [weak self] _ in
            let deleteAction = UIAction(
                title: "Удалить",
                image: nil,
                attributes: .destructive
            ) { _ in
                self?.showAlertWithCancel(
                    with: alertModel,
                    alertStyle: .actionSheet,
                    actionStyle: .destructive
                ) { _ in
                    self?.viewModel.deleteCategory(at: indexPath)
                }
            }
            return UIMenu(title: "", children: [deleteAction])
        }
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.25) {
            self.blurEffectView.alpha = 1
        }
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        UIView.animate(withDuration: 0.25) {
            self.blurEffectView.alpha = 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectCategory(indexPath)
    }
}

extension CategoryView: AddCategoryDelegate {
    
    func addCategory() {
        dismiss(animated: true)
    }
}
