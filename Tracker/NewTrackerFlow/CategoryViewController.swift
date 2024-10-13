//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Денис Максимов on 09.10.2024.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func didRecieveCategory(_ categoryIndex: Int)
}

final class CategoryViewController: UIViewController {
    
    //MARK: - Init
    
    init(delegate: CategoryViewControllerDelegate? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    
    weak var delegate: CategoryViewControllerDelegate?
    var category: String?
    private var categories = TrackerCategoryProvider.shared
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    } ()
    
    private lazy var imageStubView: UIImageView = {
        let imageView = UIImageView(image: .trackersImageStub)
        return imageView
    } ()
    
    private lazy var labelStub: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно \nобъединить по смыслу"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    } ()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = true
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    } ()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить категорию", for: .normal)
        button.backgroundColor = .ypBlack
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        return button
    } ()

    
    //MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        addSubviews()
        showStubsOrTrackers()
    }
    
    //MARK: - Methods
    
    @objc private func addCategoryButtonTapped() {
        let addCategoryViewController = AddCategoryViewController(delegate: self)
        addCategoryViewController.modalPresentationStyle = .popover
        present(addCategoryViewController, animated: true)
    }
    
    private func showStubsOrTrackers() {
        tableView.reloadData()
        if categories.categoriesProvider.isEmpty {
            labelStub.isHidden = false
            imageStubView.isHidden = false
        } else {
            labelStub.isHidden = true
            imageStubView.isHidden = true
        }
    }
    
    private func addSubviews() {
        [titleLabel, tableView, addCategoryButton, imageStubView, labelStub].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            imageStubView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageStubView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            labelStub.heightAnchor.constraint(equalToConstant: 36),
            labelStub.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            labelStub.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            labelStub.topAnchor.constraint(equalTo: imageStubView.bottomAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -24),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

//MARK: - Extensions

extension CategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.categoriesProvider.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.layer.cornerRadius = 0
        cell.separatorInset = .zero
        cell.selectionStyle = .none
        cell.backgroundColor = .ypLightGray.withAlphaComponent(0.3)
        cell.textLabel?.text = categories.categoriesProvider[indexPath.row].title
        cell.accessoryType = cell.textLabel?.text == category ? .checkmark : .none
        if categories.categoriesProvider.count == 1 {
            cell.layer.cornerRadius = 16
        } else if indexPath.row == 0 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        } else if indexPath.row == categories.categoriesProvider.count - 1 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.separatorInset = .init(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else {
            cell.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension CategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for item in 0..<categories.categoriesProvider.count {
            let cell = tableView.cellForRow(at: IndexPath(row: item, section: 0))
            cell?.accessoryType = .none
        }
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
//        guard let newCategory = cell?.textLabel?.text else { return }
        delegate?.didRecieveCategory(indexPath.row)
        dismiss(animated: true)
    }
}

extension CategoryViewController: AddCategoryDelegate {
    
    func addCategory(_ category: TrackerCategory) {
        categories.categoriesProvider.append(category)
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}
