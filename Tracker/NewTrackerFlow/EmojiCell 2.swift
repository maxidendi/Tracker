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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Properties
    
    static let reuseIdentifier: String = "emojiCell"
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    } ()

    //MARK: - Methods
    
    func configureCell(
        emoji: String
    ) {
        emojiLabel.text = emoji
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
