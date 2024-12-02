import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testTrackersViewController() throws {
        let dataProvider = DataProviderMock()
        let trackersViewModel = TrackersViewModel(dataProvider: dataProvider)
        
        let trackersView = TrackersView(viewModel: trackersViewModel)
        let navigationControllerTrack = UINavigationController(rootViewController: trackersView)
        trackersView.tabBarItem = UITabBarItem(
            title: Constants.TrackersViewControllerConstants.title,
            image: .tabTrackersIcon,
            selectedImage: nil)
        
        let statisticsViewController = StatisticViewController(dataProvider: dataProvider)
        let navigationControllerStat = UINavigationController(rootViewController: statisticsViewController)
        statisticsViewController.tabBarItem = UITabBarItem(
            title: Constants.StatisticViewControllerConstants.title,
            image: .tabStatIcon,
            selectedImage: nil)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [navigationControllerTrack, navigationControllerStat]
        tabBarController.view.backgroundColor = .ypWhite
        tabBarController.tabBar.barTintColor = .ypWhite
        tabBarController.tabBar.tintColor = .ypBlue

        tabBarController.overrideUserInterfaceStyle = .light
        assertSnapshot(of: tabBarController, as: .image, named: "LightMode")
        tabBarController.overrideUserInterfaceStyle = .dark
        assertSnapshot(of: tabBarController, as: .image, named: "DarkMode")
    }
}
