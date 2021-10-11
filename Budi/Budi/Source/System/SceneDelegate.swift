//
//  SceneDelegate.swift
//  Budi
//
//  Created by 최동규 on 2021/09/26.
//

import UIKit

// swiftlint:disable all
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var coordinator: MainTabBarCoordinator?
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let tabBarController = UITabBarController()
        guard let windowScene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: windowScene)
        coordinator = MainTabBarCoordinator(tabBarController: tabBarController)
        coordinator?.start()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

}
