//
//  File.swift
//  Tracker
//
//  Created by Денис Максимов on 08.10.2024.
//

import UIKit

final class CategoryAndScheduleCell: UITableViewCell {
    
    //MARK: - Init
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        contentView.backgroundColor = .ypLightGray.withAlphaComponent(0.3)
    }
    
    //MARK: - Properties

    static let identifier: String = "categoryAndScheduleCell"
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .left
        label.textColor = .ypBlack
        return label
    } ()
    
    private lazy var chevron: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .chevron
        imageView.tintColor = .ypGray
        return imageView
    } ()

    //MARK: - Methods
    
    func configureCell(_ text: String) {
        label.text = text
    }
    
    private func addSubviews() {
        [label, chevron].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.heightAnchor.constraint(equalToConstant: 22),
            chevron.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chevron.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
