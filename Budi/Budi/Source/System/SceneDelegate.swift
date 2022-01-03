//
//  SceneDelegate.swift
//  Budi
//
//  Created by 최동규 on 2021/09/26.
//

import UIKit
import NaverThirdPartyLogin
// swiftlint:disable all
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

//    var coordinator: MainTabBarCoordinator?
    var coordinator: LoginCoordinator?
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        /* 원래 코드 */

//        let tabBarController = UITabBarController()
//        guard let windowScene = scene as? UIWindowScene else { return }
//
//        window = UIWindow(windowScene: windowScene)
//        coordinator = MainTabBarCoordinator(tabBarController: tabBarController)
//        coordinator?.start()
//        window?.rootViewController = tabBarController
//        window?.makeKeyAndVisible()


        let navigationController = UINavigationController()
        guard let windowScene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: windowScene)
        coordinator = LoginCoordinator(navigationController: navigationController)
        coordinator?.start()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        NaverThirdPartyLoginConnection
            .getSharedInstance()?
            .receiveAccessToken(URLContexts.first?.url)
    }
}
