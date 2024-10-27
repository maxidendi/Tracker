//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Денис Максимов on 09.10.2024.
//

import UIKit

final class CategoryViewController: UIViewController {
    
    //MARK: - Init
    
    init(dataProvider: DataProviderProtocol,
         category: String?,
         delegate: CategoryViewControllerDelegate? = nil
    ) {
        self.dataProvider = dataProvider
        self.category = category
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    
    weak var delegate: CategoryViewControllerDelegate?
    private var category: String?
    private let dataProvider: DataProviderProtocol
    private let constants = Constants.CategoryViewControllerConstants.self
    private var categories: [TrackerCategory] {
        dataProvider.getCategories()
    }
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
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        showStubsOrCategories()
    }
    
    //MARK: - Methods
    
    @objc private func addCategoryButtonTapped() {
        let addCategoryViewController = AddCategoryViewController(dataProvider: dataProvider,
                                                                  delegate: self)
        addCategoryViewController.modalPresentationStyle = .popover
        present(addCategoryViewController, animated: true)
    }
    
    private func showStubsOrCategories() {
        tableView.reloadData()
        let isEmpty = categories.isEmpty
        labelStub.isHidden = !isEmpty
        imageStubView.isHidden = !isEmpty
    }
}

//MARK: - Extensions

extension CategoryViewController: SetupSubviewsProtocol {
    
    func addSubviews() {
        [titleLabel, tableView, addCategoryButton, imageStubView, labelStub].forEach {
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

extension CategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.layer.cornerRadius = .zero
        cell.selectionStyle = .none
        cell.backgroundColor = .ypLightGray.withAlphaComponent(0.3)
        cell.textLabel?.text = categories[indexPath.row].title
        cell.accessoryType = cell.textLabel?.text == category ? .checkmark : .none
        if categories.count == 1 {
            cell.layer.cornerRadius = Constants.General.radius16
            cell.separatorInset = .init(top: .zero, left: .zero, bottom: .zero, right: tableView.bounds.width)
        } else if indexPath.row == .zero {
            cell.layer.cornerRadius = Constants.General.radius16
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.separatorInset = Constants.General.separatorInsets
        } else if indexPath.row == categories.count - 1 {
            cell.layer.cornerRadius = Constants.General.radius16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.separatorInset = .init(top: .zero, left: .zero, bottom: .zero, right: tableView.bounds.width)
        } else {
            cell.separatorInset = Constants.General.separatorInsets
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.General.itemHeight
    }
}

extension CategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for item in 0..<categories.count {
            let cell = tableView.cellForRow(at: IndexPath(row: item, section: .zero))
            cell?.accessoryType = .none
        }
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        guard let text = cell?.textLabel?.text else { return }
        delegate?.didRecieveCategory(text)
        dismiss(animated: true)
    }
}

extension CategoryViewController: AddCategoryDelegate {
    
    func addCategory(_ category: TrackerCategory) {
        showStubsOrCategories()
    }
}
