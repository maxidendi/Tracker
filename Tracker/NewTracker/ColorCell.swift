//
//  ColorCell.swift
//  Tracker
//
//  Created by Денис Максимов on 07.10.2024.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Properties
    
    static let reuseIdentifier: String = "colorCell"
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    } ()

    //MARK: - Methods
    
    func configureCell(
        color: UIColor
    ) {
        colorView.backgroundColor = color
    }

    private func addSubviews() {
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
