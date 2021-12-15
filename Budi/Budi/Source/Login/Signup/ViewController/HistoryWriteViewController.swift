//
//  HistoryWriteViewController.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/25.
//

import UIKit
import CombineCocoa
import Combine
class HistoryWriteViewController: UIViewController {
    var viewModel: SignupViewModel
    weak var coordinator: LoginCoordinator?
    private var cancellables = Set<AnyCancellable>()
    private var currentButtonTag: Int = 0
    @IBOutlet weak var historyNoSwitchView: UIView!
    @IBOutlet weak var historySwitchView: UIView!
    @IBOutlet weak var modalView: UIView!

    @IBOutlet weak var firstTextField: UITextField!

    @IBOutlet weak var workingSwitchButton: UIButton!
    @IBOutlet weak var leftDatePick: UITextField!
    @IBOutlet weak var rightDatePick: UITextField!
    @IBOutlet weak var secondTextField: UITextField!

    @IBOutlet weak var saveButton: UIButton!
    private var flag = false

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardAction()
        viewModel.state.reUseModalView
            .receive(on: DispatchQueue.main)
            .sink { data in
                switch data {
                case .company:
                    self.historyNoSwitchView.isHidden = true
                    self.historySwitchView.isHidden = false
                case .project:
                    self.historyNoSwitchView.isHidden = false
                    self.historySwitchView.isHidden = true
                case .none:
                    break
                }
            }
            .store(in: &cancellables)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardAction()
    }

    init?(coder: NSCoder, viewModel: SignupViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("This viewController must be init with viewModel")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        self.addBackButton()
        configureLayout()
        setButtonAction()
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

    private func setButtonAction() {

        firstTextField.textPublisher
            .receive(on: DispatchQueue.global())
            .sink { [weak self] text in
                guard let text = text else { return }
                self?.viewModel.action.firstReuseTextField.send(text)
            }
            .store(in: &cancellables)

        saveButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink {
                print("할루~")
            }
            .store(in: &cancellables)

    }

    private func configureLayout() {
        modalView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        modalView.layer.cornerRadius = 10
    }

}
