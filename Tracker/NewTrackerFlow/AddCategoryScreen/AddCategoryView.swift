//
//  AddCategoryViewController.swift
//  Tracker
//
//  Created by Денис Максимов on 12.10.2024.
//

import UIKit

final class AddCategoryView: UIViewController, SetupSubviewsProtocol {
    
    //MARK: - Init
    
    init(viewModel: AddCategoryViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    
    private let viewModel: AddCategoryViewModelProtocol
    private let constants = Constants.AddCategoryViewControllerConstants.self
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = constants.title
        label.textAlignment = .center
        label.font = Constants.Typography.medium16
        return label
    } ()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        let view = UIView(frame: CGRect(x: .zero, y: .zero,
                                        width: Constants.General.inset16,
                                        height: Constants.General.itemHeight))
        textField.delegate = self
        textField.leftView = view
        textField.leftViewMode = .always
        textField.placeholder = constants.textFieldPlaceholderText
        textField.backgroundColor = .ypLightGray.withAlphaComponent(0.3)
        textField.font = Constants.Typography.regular17
        textField.layer.cornerRadius = Constants.General.radius16
        textField.layer.masksToBounds = true
        return textField
    } ()

    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(constants.doneButtonTitle, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.isEnabled = false
        button.backgroundColor = .ypGray
        button.titleLabel?.font = Constants.Typography.medium16
        button.layer.cornerRadius = Constants.General.radius16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(doneButtonuttonTapped), for: .touchUpInside)
        return button
    } ()
    
    //MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        bind()
        addSubviews()
        layoutSubviews()
        setupToHideKeyboard()
    }
    
    //MARK: - Methods
    
    private func bind() {
        viewModel.onDoneButtonStateChanged = { [weak self] isChanged in
            self?.changeDoneButtonState(isChanged)
        }
        viewModel.onShowAlert = { [weak self] alert in
            self?.showAlert(with: alert, alertStyle: .alert, actionStyle: .default, handler: nil)
        }
    }
    
    @objc private func doneButtonuttonTapped() {
        viewModel.doneButtonTapped()
        dismiss(animated: true)
    }
    
    private func changeDoneButtonState(_ isEnabled: Bool) {
        doneButton.isEnabled = isEnabled
        doneButton.backgroundColor = isEnabled ? .ypBlack : .ypGray
    }
    
    func addSubviews() {
        [titleLabel, textField, doneButton].forEach {
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
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                               constant: Constants.General.inset16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                constant: -Constants.General.inset16),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                           constant: constants.verticalSpacing),
            textField.heightAnchor.constraint(equalToConstant: Constants.General.itemHeight),
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

//MARK: - Extensions

extension AddCategoryView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        viewModel.checkCategoryName(text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
