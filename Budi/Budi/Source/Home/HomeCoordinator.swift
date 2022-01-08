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
        let viewController: HomeContainerViewController = storyboard.instantiateViewController(
            identifier: HomeContainerViewController.identifier) { coder -> HomeContainerViewController? in
                let allVC = HomeContentViewController(viewModel: HomeAllContentViewModel())
                let developerVC = HomeContentViewController(viewModel: HomeDeveloperContentViewModel())
                let designerVC = HomeContentViewController(viewModel: HomeDesignerContentViewModel())
                let productManagerVC = HomeContentViewController(viewModel: HomeProductManagerContentViewModel())

                return HomeContainerViewController(coder: coder, contentViewControllers: [allVC, developerVC, designerVC, productManagerVC])
            }
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - HomeWritingViewController
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
    
    func showWritingPartBottomViewController(_ vc: UIViewController, _ viewModel: HomeWritingViewModel) {
        let viewController: HomeWritingPartBottomViewController = HomeWritingPartBottomViewController(nibName: HomeWritingPartBottomViewController.identifier, bundle: nil, viewModel: viewModel)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.coordinator = self
        viewController.delegate = vc as? HomeWritingPartBottomViewControllerDelegate
        vc.present(viewController, animated: false, completion: nil)
    }
    
    func showDatePickerViewController(_ vc: UIViewController, _ isStartDate: Bool, _ limitDate: Date?) {
        let viewController: DatePickerBottomViewController = DatePickerBottomViewController(nibName: DatePickerBottomViewController.identifier, bundle: nil, isStartDate: isStartDate, limitDate: limitDate)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.delegate = vc as? DatePickerBottomViewControllerDelegate
        vc.present(viewController, animated: false, completion: nil)
    }
    
    func showLocationSearchViewController(_ vc: UIViewController) {
        let viewController = HomeLocationSearchViewController()
        viewController.navigationItem.title = "위치선택"
        viewController.delegate = vc as? HomeLocationSearchViewControllerDelegate
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showProjectMembersBottomViewController(_ vc: UIViewController, _ viewModel: HomeWritingViewModel) {
        let viewController: ProjectMembersBottomViewController = ProjectMembersBottomViewController(nibName: ProjectMembersBottomViewController.identifier, bundle: nil, developerPositions: viewModel.state.developerPositions.value, designerPositions: viewModel.state.designerPositions.value, productManagerPositions: viewModel.state.productManagerPositions.value)
        viewController.modalPresentationStyle = .overCurrentContext
        vc.present(viewController, animated: false, completion: nil)
    }
}

// MARK: - HomeDetailViewController
extension HomeCoordinator {
    func showDetail(_ postId: Int) {
        let viewController: HomeDetailViewController = storyboard.instantiateViewController(
            identifier: HomeDetailViewController.identifier) { coder -> HomeDetailViewController? in
                let viewModel = HomeDetailViewModel(postId)
                return HomeDetailViewController(coder: coder, viewModel: viewModel)
            }
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showRecruitingStatusBottomViewController(_ vc: UIViewController, _ viewModel: HomeDetailViewModel) {
        let viewController: RecruitingStatusBottomViewController = RecruitingStatusBottomViewController(nibName: RecruitingStatusBottomViewController.identifier, bundle: nil, viewModel: viewModel)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.coordinator = self
        viewController.delegate = vc as? RecruitingStatusBottomViewControllerDelegate
        vc.present(viewController, animated: false, completion: nil)
    }
    
    func showGreetingAlertViewController(_ vc: UIViewController) {
        let viewController: GreetingAlertViewController = GreetingAlertViewController(nibName: GreetingAlertViewController.identifier, bundle: nil)
        viewController.modalPresentationStyle = .overCurrentContext
        vc.present(viewController, animated: false, completion: nil)
    }
}
