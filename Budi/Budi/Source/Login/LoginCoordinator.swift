//
//  LoginCoordinator.swift
//  Budi
//
//  Created by ITlearning on 2021/11/02.
//

import UIKit

final class LoginCoordinator: NavigationCoordinator {

    weak var navigationController: UINavigationController?
    private let storyboard = UIStoryboard(name: "Main", bundle: nil)

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController: LoginSelectViewController = storyboard.instantiateViewController(identifier: LoginSelectViewController.identifier)
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }

}

extension LoginCoordinator {
    func showLoginWithNaver() {
        let viewController: SignupNormalViewController = storyboard.instantiateViewController(identifier: SignupNormalViewController.identifier)
        viewController.navigationItem.title = "회원가입"
        navigationController?.pushViewController(viewController, animated: true)
    }
}
