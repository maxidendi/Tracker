//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Денис Максимов on 10.10.2024.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    //MARK: - Init
    
    init(delegate: ScheduleViewControllerDelegate? = nil,
         schedule: Set<WeekDay>) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.schedule = schedule
        addObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    
    weak var delegate: ScheduleViewControllerDelegate?
    private var schedule: Set<WeekDay> = [] {
        didSet {
            if schedule.isEmpty {
                scheduleIsEmpty = true
            } else {
                scheduleIsEmpty = false
            }
        }
    }
    @objc dynamic private var scheduleIsEmpty: Bool = false
    private let constants = Constants.ScheduleViewControllerConstants.self
    private var scheduleObserver: NSKeyValueObservation?
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
        button.isEnabled = schedule.isEmpty ? false : true
        button.backgroundColor = schedule.isEmpty ? .ypGray : .ypBlack
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
    }
    
    //MARK: - Methods
    
    @objc private func appendWeekday(_ sender: UISwitch) {
        if sender.isOn {
            schedule.insert(WeekDay.allCases[sender.tag])
        } else {
            schedule.remove(WeekDay.allCases[sender.tag])
        }
    }
    
    @objc private func buttonTapped() {
        delegate?.didRecieveSchedule(schedule)
        dismiss(animated: true)
    }
    
    private func addObserver() {
        scheduleObserver = self.observe(\.scheduleIsEmpty,
                                         options: [.new],
                                         changeHandler: { [weak self] _, isEmpty  in
            guard let self, let isEmpty = isEmpty.newValue else { return }
            changeDoneButtonState(isEmpty)
        })
    }
    
    private func changeDoneButtonState(_ scheduleIsEmpty: Bool) {
        doneButton.isEnabled = scheduleIsEmpty ? false : true
        doneButton.backgroundColor = scheduleIsEmpty ? .ypGray : .ypBlack
    }
}

//MARK: - Extensions

extension ScheduleViewController: SetupSubviewsProtocol {
    
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

extension ScheduleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .ypLightGray.withAlphaComponent(0.3)
        let weekDay = WeekDay.allCases
        cell.textLabel?.text = weekDay[indexPath.row].rawValue
        cell.selectionStyle = .none
        let switcher = UISwitch()
        switcher.tag = indexPath.row
        switcher.isOn = schedule.contains(weekDay[indexPath.row]) ? true : false
        switcher.onTintColor = .ypBlue
        switcher.addTarget(self,
                           action: #selector(appendWeekday),
                           for: .valueChanged)
        cell.accessoryView = switcher
        if weekDay.count == 1 {
            cell.layer.cornerRadius = Constants.General.radius16
        } else if indexPath.row == .zero {
            cell.layer.cornerRadius = Constants.General.radius16
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.separatorInset = Constants.General.separatorInsets
        } else if indexPath.row == weekDay.count - 1 {
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

extension ScheduleViewController: UITableViewDelegate {
    
}
