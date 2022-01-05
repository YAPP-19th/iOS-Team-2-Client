//
//  TeamSearchCoordinator.swift
//  Budi
//
//  Created by 최동규 on 2021/10/11.
//

import UIKit
import simd

final class TeamSearchCoordinator: NavigationCoordinator {

    weak var parentCoordinator: MainTabBarCoordinator?
    weak var navigationController: UINavigationController?
    private let storyboard = UIStoryboard(name: "Main", bundle: nil)

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController

    }

    func start() {
        let viewController: TeamSearchViewController = storyboard.instantiateViewController(
            identifier: TeamSearchViewController.identifier) { coder -> TeamSearchViewController? in
                return TeamSearchViewController(coder: coder, viewModel: TeamSearchViewModel())
            }
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension TeamSearchCoordinator {

}
