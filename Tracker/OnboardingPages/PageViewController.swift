//
//  FirstPageViewController.swift
//  Tracker
//
//  Created by Денис Максимов on 06.11.2024.
//

import UIKit

final class PageViewController: UIViewController, SetupSubviewsProtocol {
    
    //MARK: - Init
    
    init(isFirstPage: Bool) {
        self.isFirstPage = isFirstPage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    
    private let isFirstPage: Bool
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = isFirstPage ? "Отслеживайте только то, что хотите" :
                                   "Даже если это не литры воды и йога"
        label.textColor = .black
        label.numberOfLines = 0
        label.font = Constants.Typography.bold32
        label.textAlignment = .center
        return label
    } ()
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Вот это технологии!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .black
        button.layer.cornerRadius = Constants.General.radius16
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    } ()
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = isFirstPage ? UIImage(named: "onboardingFirstPageImage") :
                                        UIImage(named: "onboardingSecondPageImage")
        imageView.contentMode = .scaleAspectFill
        return imageView
    } ()

    //MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        layoutSubviews()
    }

    //MARK: - Methods

    @objc private func didTapButton() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first
        else {
            assertionFailure("Invalid window configuration")
            return
        }
        window.rootViewController = TrackerTabBarController()
    }
    
    func addSubviews() {
        [imageView, label, button].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func layoutSubviews() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                          constant: -view.safeAreaLayoutGuide.layoutFrame.height * 0.37),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
