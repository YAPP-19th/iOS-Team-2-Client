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
            identifier: HomeWritingViewController.identifier) { coder -> HomeWritingViewController? in
                let viewModel = HomeWritingViewModel()
                return HomeWritingViewController(coder: coder, viewModel: viewModel)
            }
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showWritingImageBottomView(_ vc: UIViewController, _ viewModel: HomeWritingViewModel) {
        let viewController: HomeWritingImageBottomViewController = HomeWritingImageBottomViewController(nibName: HomeWritingImageBottomViewController.identifier, bundle: nil, viewModel: viewModel)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.coordinator = self
        vc.present(viewController, animated: false, completion: nil)
    }
}

extension HomeCoordinator {
    func showDetail() {
        let viewController: HomeDetailViewController = storyboard.instantiateViewController(
            identifier: HomeDetailViewController.identifier) { coder -> HomeDetailViewController? in
                let viewModel = HomeDetailViewModel()
                return HomeDetailViewController(coder: coder, viewModel: viewModel)
            }
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showDetailBottomView(_ vc: UIViewController, _ viewModel: HomeDetailViewModel) {
        let viewController: HomeDetailBottomViewController = HomeDetailBottomViewController(nibName: HomeDetailBottomViewController.identifier, bundle: nil, viewModel: viewModel)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.coordinator = self
        vc.present(viewController, animated: false, completion: nil)
    }
}
