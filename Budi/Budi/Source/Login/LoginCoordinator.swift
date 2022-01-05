//
//  LoginCoordinator.swift
//  Budi
//
//  Created by ITlearning on 2021/11/02.
//

import UIKit

final class LoginCoordinator: NavigationCoordinator {
    weak var navigationController: UINavigationController?
    private let storyboard = UIStoryboard(name: "Main", bundle: nil)

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController: LoginSelectViewController = storyboard.instantiateViewController(
            identifier: LoginSelectViewController.identifier)
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }

}

extension LoginCoordinator {
    func showSignupNormalViewController(userLogininfo: LoginUserInfo) {
        let viewController: PersonalInformationViewController = storyboard.instantiateViewController(identifier: PersonalInformationViewController.identifier) { [weak self] coder -> PersonalInformationViewController? in
            guard let self = self else { return nil }
            let viewModel = SignupViewModel()
            viewModel.state.loginUserInfo = userLogininfo
            
            return PersonalInformationViewController(coder: coder, viewModel: viewModel)
        }
        viewController.navigationItem.title = "회원가입"
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }

    func showHistoryManagementViewController(viewModel: SignupViewModel) {
        let viewController: HistoryManagementViewController = storyboard.instantiateViewController(identifier: HistoryManagementViewController.identifier) { coder -> HistoryManagementViewController? in

            return HistoryManagementViewController(coder: coder, viewModel: viewModel)
        }
        viewController.navigationItem.title = "회원가입"
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }

    func showLocationSearchViewController(viewModel: SignupViewModel) {
        let viewController: LocationSearchViewController = storyboard.instantiateViewController(identifier: LocationSearchViewController.identifier) { coder -> LocationSearchViewController? in
            return LocationSearchViewController(coder: coder, viewModel: viewModel)
        }
        viewController.navigationItem.title = "위치선택"
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }

    func showPositionViewController(viewModel: SignupViewModel) {
        let viewController: PositionViewController = storyboard.instantiateViewController(identifier: PositionViewController.identifier) { coder -> PositionViewController? in
            return PositionViewController(coder: coder, viewModel: viewModel)
        }
        viewController.navigationItem.title = "회원가입"
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }

    func showCareerViewController(viewModel: SignupViewModel) {
        let viewController: HistoryWriteViewController = storyboard.instantiateViewController(identifier: HistoryWriteViewController.identifier) { coder -> HistoryWriteViewController? in
            return HistoryWriteViewController(coder: coder, viewModel: viewModel)
        }

        viewController.coordinator = self
        viewController.viewModel.action.switchView.send(ModalControl.career)
        viewController.modalPresentationStyle = .overFullScreen
        navigationController?.present(viewController, animated: true, completion: nil)
    }

    func showProjectViewController(viewModel: SignupViewModel) {
        let viewController: HistoryWriteViewController = storyboard.instantiateViewController(identifier: HistoryWriteViewController.identifier) { coder -> HistoryWriteViewController? in
            return HistoryWriteViewController(coder: coder, viewModel: viewModel)
        }
        viewController.coordinator = self
        viewController.viewModel.action.switchView.send(ModalControl.project)
        viewController.modalPresentationStyle = .overFullScreen
        navigationController?.present(viewController, animated: true, completion: nil)
    }

    func showPortfolioController(viewModel: SignupViewModel) {
        let viewController: PortfolioViewController = storyboard.instantiateViewController(identifier: PortfolioViewController.identifier) { coder -> PortfolioViewController? in
            return PortfolioViewController(coder: coder, viewModel: viewModel)
        }
        viewController.coordinator = self
        viewController.modalPresentationStyle = .overFullScreen
        viewController.viewModel.action.switchView.send(ModalControl.portfolio)
        navigationController?.present(viewController, animated: true, completion: nil)
    }
}
