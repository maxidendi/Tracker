import UIKit

extension UITableViewCell {
    func setSeparatorAndCorners(rows: Int, indexPath: IndexPath?) {
        guard let indexPath else { return }
        if rows == 1 {
            self.layer.cornerRadius = Constants.General.radius16
            self.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner]
            self.separatorInset = .init(
                top: .zero,
                left: .zero,
                bottom: .zero,
                right: self.bounds.width)
            return
        } else if indexPath.row == .zero {
            self.layer.cornerRadius = Constants.General.radius16
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.separatorInset = Constants.General.separatorInsets
        } else if indexPath.row == rows - 1 {
            self.layer.cornerRadius = Constants.General.radius16
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            self.separatorInset = .init(
                top: .zero,
                left: .zero,
                bottom: .zero,
                right: self.bounds.width)
        } else {
            self.separatorInset = Constants.General.separatorInsets
            self.layer.maskedCorners = []
        }
        self.layoutSublayers(of: self.layer)
    }
}
