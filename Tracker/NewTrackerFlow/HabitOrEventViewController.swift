//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Денис Максимов on 05.10.2024.
//

import UIKit

final class HabitOrEventViewController: UIViewController {
    
    //MARK: - Properties
    
    weak var delegate: HabitOrEventViewControllerDelegate?
    private let constants = Constants.HabitOrEventViewControllerConstants.self
    private lazy var habitTrackerButton: UIButton = {
        let button = UIButton()
        button.addTarget(self,
                         action: #selector(showHabitOrEventViewController(_:)),
                         for: .touchUpInside)
        button.setTitle(constants.habitButtonTitle, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = Constants.Typography.medium16
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = Constants.General.radius16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    private lazy var eventTrackerButton: UIButton = {
        let button = UIButton()
        button.addTarget(self,
                         action: #selector(showHabitOrEventViewController(_:)),
                         for: .touchUpInside)
        button.setTitle(constants.eventButtonTitle, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = Constants.Typography.medium16
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = Constants.General.radius16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.text = constants.title
        label.textAlignment = .center
        label.font = Constants.Typography.medium16
        return label
    } ()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [habitTrackerButton,
                                                       eventTrackerButton])
        stackView.contentMode = .scaleAspectFill
        stackView.axis = .vertical
        stackView.spacing = constants.buttonsSpacing
        return stackView
    } ()
    
    //MARK: - Methods of lifecircle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        addSubviews()
        layoutSubviews()
    }
    
    //MARK: - Methods

    @objc private func showHabitOrEventViewController(_ sender: UIButton) {
        let vc = sender === habitTrackerButton ?
                                NewTrackerViewController(isHabit: true, dataProvider: DataProvider()) :
                                NewTrackerViewController(isHabit: false, dataProvider: DataProvider())
        vc.delegate = self
        vc.modalPresentationStyle = .popover
        present(vc, animated: true)
    }
}

//MARK: - Extensions

extension HabitOrEventViewController: SetupSubviewsProtocol {
    
    func addSubviews() {
        [stackView, titleLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func layoutSubviews() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: constants.titleTopInset),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: constants.titleHeigth),
            habitTrackerButton.heightAnchor.constraint(equalToConstant: constants.buttonHeight),
            eventTrackerButton.heightAnchor.constraint(equalToConstant: constants.buttonHeight),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                               constant: constants.buttonsStackHorizontalPadding),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                constant: -constants.buttonsStackHorizontalPadding),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                               constant: constants.stackViewYInset)
        ])
    }
}

extension HabitOrEventViewController: NewCategoryViewControllerDelegate {
    
    func dismissNewTrackerFlow() {
        dismiss(animated: true)
        delegate?.needToReloadCollectionView()
    }
}
