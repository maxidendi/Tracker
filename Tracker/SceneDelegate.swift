//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Денис Максимов on 27.09.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UserDefaultsService.shared.isFirstLaunch() ?
            OnboardingPagesViewController(
                transitionStyle: .scroll,
                navigationOrientation: .horizontal) :
            TrackerTabBarController()
        window?.makeKeyAndVisible()
    }
}

