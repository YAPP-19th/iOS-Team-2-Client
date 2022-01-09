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

    var coordinator: MainTabBarCoordinator?
    var loginCoordinator: LoginCoordinator?
    var window: UIWindow?
    var isSwitch: Bool = false

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        /* 원래 코드 */
        UserDefaults.standard.set(false, forKey: "isSwitch")
        if UserDefaults.standard.bool(forKey: "isSwitch") {
            let navigationController = UINavigationController()
            guard let windowScene = scene as? UIWindowScene else { return }

            window = UIWindow(windowScene: windowScene)
            loginCoordinator = LoginCoordinator(navigationController: navigationController)
            loginCoordinator?.start()
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        } else {
            let tabBarController = UITabBarController()
            guard let windowScene = scene as? UIWindowScene else { return }

            window = UIWindow(windowScene: windowScene)
            coordinator = MainTabBarCoordinator(tabBarController: tabBarController)
            coordinator?.start()
            window?.rootViewController = tabBarController
            window?.makeKeyAndVisible()
        }
    }
    

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        NaverThirdPartyLoginConnection
            .getSharedInstance()?
            .receiveAccessToken(URLContexts.first?.url)
    }

    func moveLoginController (_ vc: UIViewController, animated: Bool) {
        // guard let으로 윈도우를 옵셔널 바인딩한 상황
        guard let window = self.window else { return }
        let navigationController = UINavigationController()
        navigationController.modalPresentationStyle = .overFullScreen
        loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator?.start()
        window.rootViewController?.present(navigationController, animated: true, completion: nil)
    }
}
