import Foundation

protocol HabitOrEventViewControllerDelegate: AnyObject {
    func getDataProvider() -> DataProviderProtocol
    func needToReloadCollectionView()
}

