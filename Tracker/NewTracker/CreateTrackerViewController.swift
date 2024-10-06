//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Денис Максимов on 05.10.2024.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    
    private lazy var habitTrackerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    private lazy var eventTrackerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Нерегулярное событие", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    } ()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [habitTrackerButton, eventTrackerButton])
        stackView.contentMode = .scaleAspectFill
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupSubviews()
    }
    
    private func setupSubviews() {
        [stackView, titleLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 13),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 42),
            habitTrackerButton.heightAnchor.constraint(equalToConstant: 60),
            eventTrackerButton.heightAnchor.constraint(equalToConstant: 60),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 28)
        ])
    }
}
