//
//  SupplementaryView.swift
//  Tracker
//
//  Created by Денис Максимов on 02.10.2024.
//

import UIKit

final class TrackersSupplementaryView: UICollectionReusableView {
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: Constants.General.supplementaryViewHorizontalPadding),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                 constant: -Constants.General.supplementaryViewHorizontalPadding)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    
    static let identifier: String = "header"
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Typography.bold19
        label.textColor = .ypBlack
        label.numberOfLines = 2
        return label
    } ()
    
    //MARK: - Methods
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
