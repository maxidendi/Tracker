//
//  EmojiCell.swift
//  Tracker
//
//  Created by Денис Максимов on 07.10.2024.
//

import UIKit

final class EmojiCell: UICollectionViewCell {
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        contentView.layer.cornerRadius = Constants.General.inset16
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Properties
    
    static let reuseIdentifier: String = "emojiCell"
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Typography.bold32
        label.textAlignment = .center
        return label
    } ()

    //MARK: - Methods
    
    func configureCell(
        emoji: String
    ) {
        emojiLabel.text = emoji
    }
    
    func cellDidSelected() {
        contentView.backgroundColor = .ypLightGray
    }
    
    func cellDidDeselected() {
        contentView.backgroundColor = .clear
    }

    private func addSubviews() {
        contentView.addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
