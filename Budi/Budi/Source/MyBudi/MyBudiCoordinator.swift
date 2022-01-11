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
    private let storyboard = UIStoryboard(name: "Main", bundle: nil)

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
    func showEditViewController(userData: LoginUserDetail?) {
        let viewModel = MyBudiEditViewModel()
        viewModel.state.loginUserData.value = userData
        let viewController: MyBudiEditViewController = MyBudiEditViewController(nibName: MyBudiEditViewController.identifier, bundle: nil, viewModel: viewModel)
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }

    func showLevelViewController(viewModel: MyBudiMainViewModel) {
        let viewController: MyBudiLevelViewController = storyboard.instantiateViewController(identifier: MyBudiLevelViewController.identifier) { coder -> MyBudiLevelViewController? in
            return MyBudiLevelViewController(coder: coder, viewModel: viewModel)
        }
        viewController.navigationItem.title = "버디 레벨"
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }

    func showProjectDetailVeiwController(viewModel: MyBudiMainViewModel) {
        let viewController: MyBudiProjectDetailViewController = storyboard.instantiateViewController(
            identifier: MyBudiProjectDetailViewController.identifier) { coder -> MyBudiProjectDetailViewController? in
                let appliedVC = MyBudiContentViewController(viewModel: viewModel)
                let participatedVC = MyBudiContentViewController(viewModel: viewModel)
                let doneVC = MyBudiContentViewController(viewModel: viewModel)

                return MyBudiProjectDetailViewController(coder: coder, contentViewControllers: [appliedVC, participatedVC, doneVC])
            }
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }

    func showLocationSearchViewController(_ vc: UIViewController) {
        let viewController = HomeLocationSearchViewController()
        viewController.navigationItem.title = "위치선택"
        viewController.delegate = vc as? HomeLocationSearchViewControllerDelegate
        navigationController?.pushViewController(viewController, animated: true)
    }

    func showProjectMembersBottomViewController(_ vc: UIViewController, _ viewModel: MyBudiEditViewModel) {
        let viewController: ProjectMembersBottomViewController = ProjectMembersBottomViewController(nibName: ProjectMembersBottomViewController.identifier, bundle: nil, developerPositions: viewModel.state.developerPositions.value, designerPositions: viewModel.state.designerPositions.value, productManagerPositions: viewModel.state.productManagerPositions.value, viewSwitch: .myBudi)
        viewController.delegate = vc as? ProjectMembersBottomViewControllerDelegate
        viewController.modalPresentationStyle = .overCurrentContext
        vc.present(viewController, animated: false, completion: nil)
    }

    func showProjectViewController(_ vc: UIViewController, viewModel: MyBudiEditViewModel) {
        let sign = SignupViewModel()
        let viewController: HistoryWriteViewController = storyboard.instantiateViewController(identifier: HistoryWriteViewController.identifier) { coder -> HistoryWriteViewController? in
            return HistoryWriteViewController(coder: coder, viewModel: SignupViewModel())
        }
        viewController.delegate = vc as? HistoryWriteViewControllerDelegate
        viewController.myBudiCoordinator = self
        viewController.viewModel.action.switchView.send(ModalControl.project)
        viewController.modalPresentationStyle = .overFullScreen
        navigationController?.present(viewController, animated: true, completion: nil)
    }

    func showPortfolioController(viewModel: MyBudiEditViewModel) {
        let signViewModel = SignupViewModel()
        let viewController: PortfolioViewController = storyboard.instantiateViewController(identifier: PortfolioViewController.identifier) { coder -> PortfolioViewController? in
            return PortfolioViewController(coder: coder, viewModel: signViewModel)
        }
        viewController.myBudiCoordinator = self
        viewController.modalPresentationStyle = .overFullScreen
        viewController.viewModel.action.switchView.send(ModalControl.portfolio)
        navigationController?.present(viewController, animated: true, completion: nil)
    }
}
