//
//  FilterViewController.swift
//  Tracker
//
//  Created by Денис Максимов on 22.11.2024.
//

import UIKit

final class FiltersViewController: UIViewController {
    
    //MARK: - Init
    
    //MARK: - Properties
    
    private let constants = Constants.FiltersViewControllerConstants.self
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = constants.title
        label.textAlignment = .center
        label.font = Constants.Typography.medium16
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
        tableView.register(FiltersCell.self, forCellReuseIdentifier: FiltersCell.identifier)
        return tableView
    } ()

    
    //MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        addSubviews()
        layoutSubviews()
    }
    
    //MARK: - Methods
}

//MARK: - Extensions

extension FiltersViewController: SetupSubviewsProtocol {
    
    func addSubviews() {
        [titleLabel, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func layoutSubviews() {
        NSLayoutConstraint.activate([
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
            tableView.heightAnchor.constraint(equalToConstant: Constants.General.itemHeight * CGFloat(Filters.allCases.count)),
        ])
    }
}

extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Filters.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FiltersCell.identifier,
            for: indexPath) as? FiltersCell
        else { return UITableViewCell() }
        cell.configure(
            title: Filters.allCases[indexPath.row].name,
            isMarked: false,
            indexPath: indexPath,
            rowsCount: Filters.allCases.count)
        return cell
    }
}

extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.General.itemHeight
    }
}
