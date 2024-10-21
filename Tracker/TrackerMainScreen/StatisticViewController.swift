//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Денис Максимов on 27.09.2024.
//

import UIKit

final class StatisticViewController: UIViewController {
    
    //MARK: - Properties
    
    private let constants = Constants.StatisticViewControllerConstants.self
    private lazy var imageStubView: UIImageView = {
        let imageView = UIImageView(image: .statisticImageStub)
        return imageView
    } ()
    
    private lazy var labelStub: UILabel = {
        let label = UILabel()
        label.text = constants.labelStubText
        label.font = Constants.Typography.medium12
        label.textAlignment = .center
        return label
    } ()

    //MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        addSubviews()
        layoutSubviews()
        setupNavigationBar()
    }
    
    //MARK: - Methods
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = constants.title
    }
}

//MARK: - Extensions

extension StatisticViewController: SetupSubviewsProtocol {
    
    func addSubviews() {
        [imageStubView, labelStub].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    func layoutSubviews() {
        NSLayoutConstraint.activate([
            imageStubView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageStubView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            labelStub.heightAnchor.constraint(equalToConstant: Constants.General.labelTextHeight),
            labelStub.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                               constant: Constants.General.inset16),
            labelStub.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                constant: -Constants.General.inset16),
            labelStub.topAnchor.constraint(equalTo: imageStubView.bottomAnchor,
                                           constant: constants.stubsSpacing)
        ])
    }
}
