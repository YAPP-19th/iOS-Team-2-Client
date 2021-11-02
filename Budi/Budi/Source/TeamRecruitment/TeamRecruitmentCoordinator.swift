//
//  TeamRecruitmentCoordinator.swift
//  Budi
//
//  Created by 최동규 on 2021/10/11.
//

import UIKit

final class TeamRecruitmentCoordinator: NavigationCoordinator {

    weak var parentCoordinator: MainTabBarCoordinator?
    weak var navigationController: UINavigationController?
    private let storyboard = UIStoryboard(name: "Main", bundle: nil)

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController: TeamRecruitmentViewController = storyboard.instantiateViewController(
            identifier: TeamRecruitmentViewController.identifier)
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension TeamRecruitmentCoordinator {
    func showWriting() {
        let viewController: TeamRecruitmentWritingViewController = storyboard.instantiateViewController(
            identifier: TeamRecruitmentWritingViewController.identifier)
        navigationController?.pushViewController(viewController, animated: true)
    }

    func showDetail() {
        let viewController: TeamRecruitmentDetailViewController = storyboard.instantiateViewController(
            identifier: TeamRecruitmentDetailViewController.identifier)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
