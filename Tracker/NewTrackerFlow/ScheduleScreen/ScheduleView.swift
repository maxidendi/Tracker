//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Денис Максимов on 10.10.2024.
//

import UIKit

final class ScheduleView: UIViewController, UITableViewDelegate {
    
    //MARK: - Init
    
    init(viewModel: ScheduleViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    
    private var viewModel: ScheduleViewModelProtocol
    private let constants = Constants.ScheduleViewControllerConstants.self
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = constants.title
        label.textAlignment = .center
        label.font = Constants.Typography.medium16
        return label
    } ()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = true
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .ypGray
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    } ()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = viewModel.isScheduleEmpty() ? false : true
        button.backgroundColor = viewModel.isScheduleEmpty() ? .ypGray : .ypBlack
        button.setTitle(constants.doneButtonTitle, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = Constants.Typography.medium16
        button.layer.cornerRadius = Constants.General.radius16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
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
        viewModel.onScheduleIsEmpty = { [weak self] isEmpty in
            self?.changeDoneButtonState(isEmpty)
        }
    }
    
    @objc private func changeWeekdays(_ sender: UISwitch) {
        if sender.isOn {
            viewModel.insertWeekday(tag: sender.tag)
        } else {
            viewModel.removeWeekday(tag: sender.tag)
        }
    }
    
    @objc private func buttonTapped() {
        viewModel.doneButtonTapped()
    }
    
    private func changeDoneButtonState(_ scheduleIsEmpty: Bool) {
        doneButton.isEnabled = scheduleIsEmpty ? false : true
        doneButton.backgroundColor = scheduleIsEmpty ? .ypGray : .ypBlack
    }
}

//MARK: - Extensions

extension ScheduleView: SetupSubviewsProtocol {
    
    func addSubviews() {
        [titleLabel, tableView, doneButton].forEach {
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
            tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor,
                                              constant: -constants.verticalSpacing),
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                constant: constants.buttonHorizontalPadding),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                 constant: -constants.buttonHorizontalPadding),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -constants.verticalSpacing),
            doneButton.heightAnchor.constraint(equalToConstant: constants.buttonHeight)
        ])
    }
}

extension ScheduleView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .ypLightGray.withAlphaComponent(0.3)
        let weekDay = WeekDay.allCases
        cell.textLabel?.text = weekDay[indexPath.row].fullName
        cell.selectionStyle = .none
        let switcher = UISwitch()
        switcher.tag = indexPath.row
        switcher.isOn = viewModel.isWeekdayAdded(tag: indexPath.row) ? true : false
        switcher.onTintColor = .ypBlue
        switcher.addTarget(self,
                           action: #selector(changeWeekdays),
                           for: .valueChanged)
        cell.accessoryView = switcher
        cell.setSeparatorAndCorners(rows: WeekDay.allCases.count, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.General.itemHeight
    }
}
