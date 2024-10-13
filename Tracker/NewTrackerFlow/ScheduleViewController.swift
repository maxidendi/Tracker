//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Денис Максимов on 10.10.2024.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    //MARK: - Init
    
    init(delegate: ScheduleViewControllerDelegate? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        addObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    
    weak var delegate: ScheduleViewControllerDelegate?
    var schedule: Set<WeekDay> = [] {
        didSet {
            if schedule.isEmpty {
                scheduleIsEmpty = true
            } else {
                scheduleIsEmpty = false
            }
        }
    }
    @objc dynamic private var scheduleIsEmpty: Bool = false
    private var scheduleObserver: NSKeyValueObservation?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    } ()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .ypLightGray.withAlphaComponent(0.3)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorInset = UIEdgeInsets(
            top: 0,
            left: 16,
            bottom: 0,
            right: 16)
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        return tableView
    } ()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = false
        button.backgroundColor = .ypGray
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    } ()
    
    //MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        addSubviews()
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
    
    private func addSubviews() {
        [titleLabel, scrollView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        [tableView, doneButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat((WeekDay.allCases.count * 75) - 1)),
            tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -24),
            
            doneButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

//MARK: - Extensions

extension ScheduleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .clear
        let weekDay = WeekDay.allCases[indexPath.row]
        cell.textLabel?.text = weekDay.rawValue
        cell.selectionStyle = .none
        let switcher = UISwitch()
        switcher.tag = indexPath.row
        switcher.isOn = schedule.contains(weekDay) ? true : false
        switcher.onTintColor = .ypBlue
        switcher.addTarget(self,
                           action: #selector(appendWeekday),
                           for: .valueChanged)
        cell.accessoryView = switcher
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension ScheduleViewController: UITableViewDelegate {
    
}
