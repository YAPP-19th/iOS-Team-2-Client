//
//  HomeCoordinator.swift
//  Budi
//
//  Created by 최동규 on 2021/10/11.
//

import UIKit

final class HomeCoordinator: NavigationCoordinator {

    weak var parentCoordinator: MainTabBarCoordinator?
    weak var navigationController: UINavigationController?
    private let storyboard = UIStoryboard(name: "Main", bundle: nil)

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController: HomeViewController = storyboard.instantiateViewController(
            identifier: HomeViewController.identifier) { coder -> HomeViewController? in
                let viewModel = HomeViewModel()
                return HomeViewController(coder: coder, viewModel: viewModel)
            }
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension HomeCoordinator {
    func showWriting() {
        let viewController: HomeWritingViewController = storyboard.instantiateViewController(
            identifier: HomeWritingViewController.identifier)
        navigationController?.pushViewController(viewController, animated: true)
    }

    func showDetail() {
        let viewController: HomeDetailViewController = storyboard.instantiateViewController(
            identifier: HomeDetailViewController.identifier) { coder -> HomeDetailViewController? in
                let viewModel = HomeDetailViewModel()
                return HomeDetailViewController(coder: coder, viewModel: viewModel)
            }
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}
