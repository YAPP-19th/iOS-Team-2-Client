//
//  PortfolioViewController.swift
//  Budi
//
//  Created by 인병윤 on 2021/12/15.
//

import UIKit
import Combine
import CombineCocoa

protocol PortfolioViewControllerDelegate: AnyObject {
    func getPortfolio(_ portfolio: SignupInfoModel)
}

class PortfolioViewController: UIViewController {

    weak var delegate: PortfolioViewControllerDelegate?
    weak var coordinator: LoginCoordinator?
    weak var myBudiCoordinator: MyBudiCoordinator?
    @IBOutlet weak var modalView: UIView!
    var viewModel: SignupViewModel
    @IBOutlet weak var emptyViewButton: UIButton!
    @IBOutlet weak var portfolioTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    private var flag = false
    private var cancellables = Set<AnyCancellable>()
    private let panGesture = UIPanGestureRecognizer()
    private var viewTranslation = CGPoint(x: 0, y: 0)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    init?(coder: NSCoder, viewModel: SignupViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("This viewController must be init with viewModel")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.action.setSignupInfoData.send(())
        keyboardAction()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardAction()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        dismissAction()
        bindButtonAction()
        bindViewModel()
    }

    private func bindButtonAction() {
        portfolioTextField.textPublisher
            .receive(on: DispatchQueue.global())
            .sink { [weak self] text in
                guard let text = text else { return }
                guard var data = self?.viewModel.state.writedInfoData.value else { return }
                data.porflioLink = text
                print(data.porflioLink)
                self?.viewModel.state.writedInfoData.send(data)
                
            }
            .store(in: &cancellables)

        saveButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.myBudiCoordinator != nil {
                    let send = self.viewModel.state.writedPortfolioData.value
                    print("입력받은 텍스트", send)
                    self.delegate?.getPortfolio(send)
                } else {
                    self.viewModel.action.fetchSignupInfoData.send(())
                }

                NotificationCenter.default.post(name: Notification.Name("Dismiss"), object: self)
                self.dismiss(animated: true, completion: nil)
            }
            .store(in: &cancellables)

        emptyViewButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                NotificationCenter.default.post(name: Notification.Name("Dismiss"), object: self)
                self.dismiss(animated: true, completion: nil)
            }
            .store(in: &cancellables)
    }

    private func bindViewModel() {
        viewModel.state.writedInfoData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self = self else { return }
                guard let data = data else { return }
                self.saveButton.isEnabled = data.porflioLink.count >= 1 ? true : false
                self.saveButton.backgroundColor = data.porflioLink.count >= 1 ? UIColor.primary : UIColor.textDisabled
                self.saveButton.setTitleColor(UIColor.white, for: .normal)
                self.saveButton.setTitleColor(UIColor.white, for: .disabled)
            }
            .store(in: &cancellables)

        viewModel.state.editData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] editData in
                guard let self = self else { return }
                guard let editData = editData else { return }
                self.portfolioTextField.text = editData.portfolioLink
                guard var data = self.viewModel.state.writedInfoData.value else { return }
                data.mainName = ""
                data.startDate = ""
                data.endDate = ""
                data.description = ""
                data.porflioLink = editData.portfolioLink
                self.viewModel.state.writedInfoData.send(data)
            }
            .store(in: &cancellables)
    }

    private func keyboardAction() {
        // 키보드 등장 시
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] keyboard in
                if self?.flag == false {
                    self?.flag = true
                    if let keyboardFrame: NSValue = keyboard.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                        let keyboardRect = keyboardFrame.cgRectValue
                        let keyboardHeight = keyboardRect.height
                        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                            self?.view.frame.origin.y -= keyboardHeight
                        })
                    }
                }
            }
            .store(in: &cancellables)
        // 키보드 나갈 시
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] keyboard in
                self?.flag = false
                if let keyboardFrame: NSValue = keyboard.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardRect = keyboardFrame.cgRectValue
                    let keyboardHeight = keyboardRect.height
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                        self?.view.frame.origin.y += keyboardHeight
                    })
                }
            }
            .store(in: &cancellables)
    }

    private func configureLayout() {
        view.backgroundColor = .clear
        emptyViewButton.setTitle("", for: .normal)
        modalView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        modalView.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 20
    }

    private func dismissAction() {
        panGesture.panPublisher
            .receive(on: DispatchQueue.main)
            .sink { sender in
                switch sender.state {
                case .changed:
                    self.viewTranslation = sender.translation(in: self.modalView)

                    if self.viewTranslation.y > 100 {
                        NotificationCenter.default.post(name: Notification.Name("Dismiss"), object: self)
                        self.dismiss(animated: true, completion: nil)
                    } else if self.viewTranslation.y > 0 {
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                            self.modalView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                        })
                    }
                case .ended:
                    break
                default:
                    if self.viewTranslation.y < 100 {
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                            self.modalView.transform = .identity
                        })
                    }
                }
            }
            .store(in: &cancellables)

        modalView.addGestureRecognizer(panGesture)

    }
}
