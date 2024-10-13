//
//  NewTrackerSupplementaaryView.swift
//  Tracker
//
//  Created by Денис Максимов on 08.10.2024.
//

import UIKit

final class NewTrackerSupplementaryView: UICollectionReusableView {
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    
    static let identifier: String = "header"
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .ypBlack
        return label
    } ()
    
    //MARK: - Methods
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
