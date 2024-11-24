import UIKit

final class CategoryCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier: String = "CategoryCell"
    
    //MARK: - Methods
    
    func configure(category: String,
                   isMarked: Bool,
                   indexPath: IndexPath,
                   rowsCount: Int
    ) {
        self.layer.cornerRadius = .zero
        self.selectionStyle = .none
        self.backgroundColor = .ypLightGray.withAlphaComponent(0.3)
        self.textLabel?.text = category
        self.accessoryType = isMarked ? .checkmark : .none
        setSeparatorAndCorners(rows: rowsCount, indexPath: indexPath)
    }
}
