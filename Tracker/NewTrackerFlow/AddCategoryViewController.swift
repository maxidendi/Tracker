//
//  AddCategoryViewController.swift
//  Tracker
//
//  Created by Денис Максимов on 12.10.2024.
//

import UIKit

protocol AddCategoryDelegate: AnyObject {
    func addCategory(_ category: TrackerCategory)
}

final class AddCategoryViewController: UIViewController {
    
    //MARK: - Init
    
    init(delegate: AddCategoryDelegate? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    
    weak var delegate: AddCategoryDelegate?
    private var categories = TrackerCategoryProvider.shared
    private var newCategory: TrackerCategory?
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая категория"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    } ()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        textField.delegate = self
        textField.leftView = view
        textField.leftViewMode = .always
        textField.placeholder = "Введите название категории"
        textField.backgroundColor = .ypLightGray.withAlphaComponent(0.3)
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        return textField
    } ()

    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.isEnabled = false
        button.backgroundColor = .ypGray
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(doneButtonuttonTapped), for: .touchUpInside)
        return button
    } ()
    
    //MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        addSubviews()
    }
    
    //MARK: - Methods
    
    @objc private func doneButtonuttonTapped() {
        guard let newCategory else { return }
        delegate?.addCategory(newCategory)
        dismiss(animated: true)
    }
    
    private func changeDoneButtonState() {
        doneButton.isEnabled = true
        doneButton.backgroundColor = .ypBlack
    }
    
    private func addSubviews() {
        [titleLabel, textField, doneButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            textField.heightAnchor.constraint(equalToConstant: 75),
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
            ])
    }
}

//MARK: - Extensions

extension AddCategoryViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text,
              text.count > 0 else {
            return
        }
        guard !categories.categoriesProvider.contains(where: { $0.title == text }) else {
            let alertModel = AlertModel(message: "Категория с таким наименованием уже существует",
                                        actionTitle: "Ok")
            showAlert(with: alertModel)
            return
        }
        let newCategory = TrackerCategory(title: text, trackers: [])
        self.newCategory = newCategory
        changeDoneButtonState()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
