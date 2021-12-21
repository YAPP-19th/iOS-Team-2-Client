//
//  MyBudiCoordinator.swift
//  Budi
//
//  Created by 최동규 on 2021/10/11.
//

import UIKit

final class MyBudiCoordinator: NavigationCoordinator {

    weak var parentCoordinator: MainTabBarCoordinator?
    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController

    }

    func start() {
        let viewController: MyBudiMainViewController = MyBudiMainViewController(nibName: MyBudiMainViewController.identifier, bundle: nil, viewModel: MyBudiMainViewModel())
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension MyBudiCoordinator {
    func showEditViewController() {
        let viewController: MyBudiEditViewController = MyBudiEditViewController(nibName: MyBudiEditViewController.identifier, bundle: nil, viewModel: MyBudiEditViewModel())
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}
