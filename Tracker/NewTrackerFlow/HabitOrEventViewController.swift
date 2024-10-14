//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Денис Максимов on 05.10.2024.
//

import UIKit

protocol NewCategoryViewControllerDelegate: AnyObject {
    
    func dismissNewTrackerFlow()
}

final class HabitOrEventViewController: UIViewController {
    
    //MARK: - Properties
    
    weak var delegate: HabitOrEventViewControllerDelegate?
    private lazy var habitTrackerButton: UIButton = {
        let button = UIButton()
        button.addTarget(self,
                         action: #selector(showHabitOrEventViewController(_:)),
                         for: .touchUpInside)
        button.setTitle("Привычка", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    private lazy var eventTrackerButton: UIButton = {
        let button = UIButton()
        button.addTarget(self,
                         action: #selector(showHabitOrEventViewController(_:)),
                         for: .touchUpInside)
        button.setTitle("Нерегулярное событие", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.text = "Создание трекера"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    } ()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [habitTrackerButton,
                                                       eventTrackerButton])
        stackView.contentMode = .scaleAspectFill
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    } ()
    
    //MARK: - Methods of lifecircle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupSubviews()
    }
    
    //MARK: - Methods

    @objc private func showHabitOrEventViewController(_ sender: UIButton) {
        let vc = sender === habitTrackerButton ? NewTrackerViewController(isHabit: true) :
                                                 NewTrackerViewController(isHabit: false)
        vc.delegate = self
        vc.modalPresentationStyle = .popover
        present(vc, animated: true)
    }
    
    private func setupSubviews() {
        [stackView, titleLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            habitTrackerButton.heightAnchor.constraint(equalToConstant: 60),
            eventTrackerButton.heightAnchor.constraint(equalToConstant: 60),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 32)
        ])
    }
}

extension HabitOrEventViewController: NewCategoryViewControllerDelegate {
    
    func dismissNewTrackerFlow() {
        dismiss(animated: true)
        delegate?.needToReloadCollectionView()
    }
}
