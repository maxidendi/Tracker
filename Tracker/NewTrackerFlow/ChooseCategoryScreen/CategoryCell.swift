//
//  CategoryCell.swift
//  Tracker
//
//  Created by Денис Максимов on 07.11.2024.
//

import UIKit

final class CategoryCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier: String = "CategoryCell"
    
    //MARK: - Methods
    
    func configure(category: String,
                   isMarked: Bool,
                   indexPath: IndexPath,
                   rowsCount: Int,
                   separatorWidth: CGFloat
    ) {
        self.layer.cornerRadius = .zero
        self.selectionStyle = .none
        self.backgroundColor = .ypLightGray.withAlphaComponent(0.3)
        self.textLabel?.text = category
        self.accessoryType = isMarked ? .checkmark : .none
        if rowsCount == 1 {
            self.layer.cornerRadius = Constants.General.radius16
            self.separatorInset = .init(top: .zero, left: .zero, bottom: .zero, right: separatorWidth)
        } else if indexPath.row == .zero {
            self.layer.cornerRadius = Constants.General.radius16
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.separatorInset = Constants.General.separatorInsets
        } else if indexPath.row == rowsCount - 1 {
            self.layer.cornerRadius = Constants.General.radius16
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            self.separatorInset = .init(top: .zero, left: .zero, bottom: .zero, right: separatorWidth)
        } else {
            self.separatorInset = Constants.General.separatorInsets
        }
    }
}
