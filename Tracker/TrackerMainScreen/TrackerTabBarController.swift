//
//  ViewController.swift
//  Tracker
//
//  Created by Денис Максимов on 27.09.2024.
//

import UIKit

final class TrackerTabBarController: UITabBarController {
    
    //MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        tabBar.barTintColor = .ypWhite
        tabBar.tintColor = .ypBlue
        setTabBarControllers()
    }
    
    //MARK: - Methods
    
    private func setTabBarControllers() {
        let trackersViewController = TrackersViewController()
        let navigationControllerTrack = UINavigationController(rootViewController: trackersViewController)
        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: .tabTrackersIcon,
            selectedImage: nil)
        
        let statisticsViewController = StatisticViewController()
        let navigationControllerStat = UINavigationController(rootViewController: statisticsViewController)
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: .tabStatIcon,
            selectedImage: nil)
        viewControllers = [navigationControllerTrack, navigationControllerStat]
    }
}

