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
    
    func showWritingImageBottomViewController(_ vc: UIViewController, _ viewModel: HomeWritingViewModel) {
        let viewController: HomeWritingImageBottomViewController = HomeWritingImageBottomViewController(nibName: HomeWritingImageBottomViewController.identifier, bundle: nil, viewModel: viewModel)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.coordinator = self
        viewController.delegate = vc as? HomeWritingImageBottomViewControllerDelegate
        vc.present(viewController, animated: false, completion: nil)
    }
    
    func showWritingPartBottomViewController(_ vc: UIViewController, _ viewModel: HomeWritingViewModel) {
        let viewController: HomeWritingPartBottomViewController = HomeWritingPartBottomViewController(nibName: HomeWritingPartBottomViewController.identifier, bundle: nil, viewModel: viewModel)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.coordinator = self
        viewController.delegate = vc as? HomeWritingPartBottomViewControllerDelegate
        vc.present(viewController, animated: false, completion: nil)
    }
    
    func showDatePickerViewController(_ vc: UIViewController, _ minimumDate: Date? = nil) {
        let viewController: DatePickerBottomViewController = DatePickerBottomViewController(nibName: DatePickerBottomViewController.identifier, bundle: nil)
        viewController.delegate = vc as? DatePickerBottomViewControllerDelegate
        viewController.modalPresentationStyle = .overCurrentContext
        vc.present(viewController, animated: false, completion: nil)
    }
    
    func showLocationSearchViewController() {
        let viewController: LocationSearchViewController = storyboard.instantiateViewController(identifier: LocationSearchViewController.identifier) { coder -> LocationSearchViewController? in
            let viewModel = SignupViewModel()
            return LocationSearchViewController(coder: coder, viewModel: viewModel)
        }
        viewController.navigationItem.title = "위치선택"
        //viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showWritingMembersBottomViewController(_ vc: UIViewController, _ viewModel: HomeWritingViewModel) {
        let viewController: HomeWritingMembersBottomViewController = HomeWritingMembersBottomViewController(nibName: HomeWritingMembersBottomViewController.identifier, bundle: nil, viewModel: viewModel)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.coordinator = self
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
