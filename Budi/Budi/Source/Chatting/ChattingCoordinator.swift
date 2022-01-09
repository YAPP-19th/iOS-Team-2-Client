//
//  ChattingCoordinator.swift
//  Budi
//
//  Created by 최동규 on 2021/10/11.
//

import UIKit

final class ChattingCoordinator: NavigationCoordinator {

    weak var parentCoordinator: MainTabBarCoordinator?
    weak var navigationController: UINavigationController?
    private let storyboard = UIStoryboard(name: "Main", bundle: nil)

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController: ChattingViewController = storyboard.instantiateViewController(
            identifier: ChattingViewController.identifier) { coder -> ChattingViewController? in
                let viewModel = ChattingViewModel()
                return ChattingViewController(coder: coder, viewModel: viewModel)
            }
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ChattingCoordinator {
    func showDetail() {
        let viewController: ChattingDetailViewController = storyboard.instantiateViewController(
            identifier: ChattingDetailViewController.identifier) { coder -> ChattingDetailViewController? in
                let viewModel = ChattingViewModel()
                return ChattingDetailViewController(coder: coder, viewModel: viewModel)
            }
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}
