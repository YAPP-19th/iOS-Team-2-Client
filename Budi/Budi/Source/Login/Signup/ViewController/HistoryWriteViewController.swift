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

    @IBOutlet weak var mainNameTextField: UITextField!

    @IBOutlet weak var workingSwitchButton: UIButton!
    @IBOutlet weak var leftDateTextField: UITextField!
    @IBOutlet weak var rightDateTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    @IBOutlet weak var mainNameMainLabel: UILabel!
    @IBOutlet weak var descriptionMainLabel: UILabel!

    @IBOutlet weak var noSwitchLeftDateTextField: UITextField!
    @IBOutlet weak var noSwitchRightDateTextField: UITextField!

    private var leftDatePicker = UIDatePicker()
    private var rightDatePicker = UIDatePicker()
    
    private var flag = false
    private let panGesture = UIPanGestureRecognizer()
    private var currentKeyboard: CGFloat = 0.0
    private var viewTranslation = CGPoint(x: 0, y: 0)
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
                    self.changeTextFieldTexts(modal: .company)
                case .project:
                    self.historyNoSwitchView.isHidden = false
                    self.historySwitchView.isHidden = true
                    self.changeTextFieldTexts(modal: .project)
                case .portfolio:
                    break
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
        dismissAction()
    }

    private func setButtonAction() {

        mainNameTextField.textPublisher
            .receive(on: DispatchQueue.global())
            .sink { [weak self] text in
                guard let text = text else { return }
                self?.viewModel.action.firstReuseTextField.send(text)
            }
            .store(in: &cancellables)

        descriptionTextField.textPublisher
            .receive(on: DispatchQueue.global())
            .sink { [weak self] text in
                guard let text = text else { return }
                self?.viewModel.action.secondReuseTextField.send(text)
            }
            .store(in: &cancellables)

        saveButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink {
                self.viewModel.action.saveResume.send(())
                NotificationCenter.default.post(name: Notification.Name("Dismiss"), object: self)
                self.dismiss(animated: true, completion: nil)
            }
            .store(in: &cancellables)

        viewModel.careerIsInvalid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] enabled in
                print(enabled)
                if enabled {
                    self?.saveButton.isEnabled = true
                    self?.saveButton.backgroundColor = UIColor.budiGreen
                    self?.saveButton.setTitleColor(UIColor.white, for: .normal)
                } else {
                    self?.saveButton.isEnabled = false
                    self?.saveButton.backgroundColor = UIColor.budiGray
                    self?.saveButton.setTitleColor(UIColor.white, for: .disabled)
                }
            }
            .store(in: &cancellables)

        workingSwitchButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                if !self.workingSwitchButton.isSelected {
                    self.workingSwitchButton.isSelected = true
                    self.workingSwitchButton.imageView?.image = UIImage(systemName: "checkmark.circle.fill")
                    self.workingSwitchButton.tintColor = UIColor.budiGreen
                    self.rightDateTextField.text = "현재"
                    self.rightDateTextField.isSelected = false
                } else {
                    self.workingSwitchButton.isSelected = false
                    self.workingSwitchButton.imageView?.image = UIImage(systemName: "checkmark.circle")
                    self.workingSwitchButton.tintColor = UIColor.systemGray
                    self.rightDateTextField.text = ""
                    self.rightDateTextField.isSelected = true
                }
            }
            .store(in: &cancellables)

        leftDatePicker.datePublisher
            .receive(on: DispatchQueue.main)
            .sink { date in
                let text = self.dateFormatter(date)
                self.leftDateTextField?.text = text
                self.noSwitchLeftDateTextField?.text = text
                self.viewModel.action.leftDatePicker.send(text)
            }
            .store(in: &cancellables)

        rightDatePicker.datePublisher
            .receive(on: DispatchQueue.main)
            .sink { date in
                let text = self.dateFormatter(date)
                self.rightDateTextField?.text = text
                self.noSwitchRightDateTextField?.text = text
                self.viewModel.action.rightDatePicker.send(text)
            }
            .store(in: &cancellables)

    }

    private func dateFormatter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년MM월dd일"
        return formatter.string(from: date)
    }

    private func configureLayout() {
        modalView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        modalView.layer.cornerRadius = 10
        leftDatePicker.preferredDatePickerStyle = .inline
        rightDatePicker.preferredDatePickerStyle = .inline
        leftDatePicker.datePickerMode = .date
        leftDatePicker.locale = Locale(identifier: "ko-KR")
        rightDatePicker.datePickerMode = .date
        rightDatePicker.locale = Locale(identifier: "ko-KR")
        leftDateTextField.inputView = leftDatePicker
        rightDateTextField.inputView = rightDatePicker
        noSwitchLeftDateTextField.inputView = leftDatePicker
        noSwitchRightDateTextField.inputView = rightDatePicker

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
        let cancel = UIBarButtonItem(title: "닫기", style: .plain, target: nil, action: #selector(tapCancel))
        toolBar.setItems([cancel], animated: true)
        leftDateTextField.inputAccessoryView = toolBar
        rightDateTextField.inputAccessoryView = toolBar
        noSwitchLeftDateTextField.inputAccessoryView = toolBar
        noSwitchRightDateTextField.inputAccessoryView = toolBar
        leftDateTextField.text = ""
        rightDateTextField.text = ""
    }

    @objc
    func tapCancel() {
        self.view.endEditing(true)
    }

    private func changeTextFieldTexts(modal: ModalControl) {
        switch modal {
        case .company:
            self.descriptionTextField.placeholder = "부서명/직책을 입력하세요"
            self.descriptionMainLabel.text = "부서명/직책"
        case .project:
            self.mainNameMainLabel.text = "프로젝트명"
            self.mainNameTextField.placeholder = "프로젝트 이름을 입력하세요"
            self.descriptionMainLabel.text = "직무/역할"
            self.descriptionTextField.placeholder = "참여한 역할을 입력하세요"
        case .portfolio:
            break
        }
    }

    private func dismissAction() {
        panGesture.panPublisher
            .receive(on: DispatchQueue.main)
            .sink { sender in
                print(self.viewTranslation.y)
                switch sender.state {
                case .changed:
                    self.viewTranslation = sender.translation(in: self.modalView)

                    if self.viewTranslation.y > 250 {
                        NotificationCenter.default.post(name: Notification.Name("Dismiss"), object: self)
                        self.dismiss(animated: true, completion: nil)
                    } else if self.viewTranslation.y > 0 {
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                            self.modalView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                        })
                    }
                case .ended:
                    print("왜 여기가 안찍히지?")
                default:
                    if self.viewTranslation.y < 250 {
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                            self.modalView.transform = .identity
                        })
                    }
                }
            }
            .store(in: &cancellables)

        modalView.addGestureRecognizer(panGesture)

    }

    private func keyboardAction() {
        // 키보드 등장 시
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] keyboard in
                    if let keyboardFrame: NSValue = keyboard.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                        let keyboardRect = keyboardFrame.cgRectValue
                        let keyboardHeight = keyboardRect.height
                        if self?.flag == false {
                            self?.flag = true
                            self?.currentKeyboard = keyboardHeight
                            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                            self?.view.frame.origin.y -= keyboardHeight
                            })
                        } else if self?.currentKeyboard != keyboardHeight {
                            if self?.currentKeyboard ?? 0 > keyboardHeight {
                                self?.view.frame.origin.y += abs(keyboardHeight - (self?.currentKeyboard ?? 0))
                            } else {
                                self?.view.frame.origin.y -= abs(keyboardHeight - (self?.currentKeyboard ?? 0))
                            }

                            self?.currentKeyboard = keyboardHeight
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

}
