import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTrackersViewController() throws {
//        isRecording = true
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
