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
        vc.present(viewController, animated: false, completion: nil)
    }
    
    func showWritingPartBottomViewController(_ vc: UIViewController, _ viewModel: HomeWritingViewModel) {
        let viewController: HomeWritingPartBottomViewController = HomeWritingPartBottomViewController(nibName: HomeWritingPartBottomViewController.identifier, bundle: nil, viewModel: viewModel)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.coordinator = self
        vc.present(viewController, animated: false, completion: nil)
    }
    
    func showDatePickerViewController(_ vc: UIViewController) {
        let viewController: DatePickerBottomViewController = DatePickerBottomViewController(nibName: DatePickerBottomViewController.identifier, bundle: nil)
        viewController.delegate = vc as? DatePickerBottomViewControllerDelegate
        viewController.modalPresentationStyle = .overCurrentContext
        vc.present(viewController, animated: false, completion: nil)
    }
    
    func showLocationSearchViewController() {
        let viewController = LocationSearchViewController()
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
