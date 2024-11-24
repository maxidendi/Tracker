import Foundation

protocol TrackerCellDelegate: AnyObject {
    func counterButtonTapped(with id: UUID, isCompleted: Bool)
}
