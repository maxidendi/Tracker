import UIKit

final class FiltersCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier: String = "FiltersCell"
    
    //MARK: - Methods
    
    func configure(title: String,
                   isMarked: Bool,
                   indexPath: IndexPath,
                   rowsCount: Int
    ) {
        self.layer.cornerRadius = .zero
        self.selectionStyle = .none
        self.backgroundColor = .ypLightGray.withAlphaComponent(0.3)
        self.textLabel?.text = title
        self.accessoryType = isMarked ? .checkmark : .none
        setSeparatorAndCorners(rows: rowsCount, indexPath: indexPath)
    }
    
    func didSelect() {
        self.accessoryType = .checkmark
    }
    
    func didDeselect() {
        self.accessoryType = .none
    }
}
