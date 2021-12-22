//
//  SignupNormalViewController.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/06.
//

import UIKit
import Combine
import CombineCocoa

class PersonalInformationViewController: UIViewController {

    weak var coordinator: LoginCoordinator?
    private var viewModel = SignupViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLayoutSubviews() {
        scrollView.updateContentView()
    }

    private let introduceView = IntroduceView()
    private let locationSelectView = LocationSelectView()
    private let nickNameView = NickNameView()
    private let darkSpacingLineView = SpacingDarkLineView()
    private var defaultConstraint: [NSLayoutConstraint] = []
    private var newConstraint: [NSLayoutConstraint] = []

    @IBOutlet weak var signupInfoLabel: UILabel!
    private let progressView: ProgressView = {
        let progress = ProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.changeColor(index: 1)
        return progress
    }()

    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor.init(white: 0, alpha: 0.38)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 25, right: 0)
        button.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        return button
    }()

    @objc
    func nextAction() {
        viewModel.pushServer()
        coordinator?.showPositionViewController()
    }

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let baseView: UIView = {
        let viewBase = UIView()
        return viewBase
    }()

    @objc
    func searchAction() {
        coordinator?.showLocationSearchViewController()
        NSLayoutConstraint.deactivate(defaultConstraint)
        NSLayoutConstraint.activate(newConstraint)
        NotificationCenter.default.post(name: NSNotification.Name("ActivationNext"), object: nil, userInfo: nil)
    }

    @objc
    func activationNextButton() {
        nextButton.isEnabled = true
        nextButton.backgroundColor = UIColor.budiGreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isEnabled = false
        scrollView.delegate = self
        self.addBackButton()
        configureAddOserver()
        configureLayout()
        keyBoardNotification()
        keyBoardDismiss()
        bindViewModel()
        setPublisher()
    }

    private func bindViewModel() {
        viewModel.state.naverData
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] data in
                self?.nickNameView.loadNameText(data?.name ?? "")
                self?.introduceView.loadTextView(data?.email ?? "")
            })
            .store(in: &cancellables)

        viewModel.state.checkIdStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] flag in
                guard let self = self else { return }
                guard let flag = flag else { return }
                self.nickNameView.checkID(flag: flag)
            }
            .store(in: &cancellables)

        viewModel.state.signUpPersonalInfoData
            .receive(on: DispatchQueue.main)
            .sink { data in
                print(data)
            }
            .store(in: &cancellables)

    }

    private func setPublisher() {
        nickNameView.nickNameTextField.textPublisher
            .throttle(for: 0.8, scheduler: DispatchQueue.main, latest: true)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                var changeData = self.viewModel.state.signUpPersonalInfoData.value
                guard let text = text else { return }
                changeData.nickName = text
                if text == "" {
                    self.nickNameView.emptyText()
                }
                self.viewModel.action.checkSameId.send(text)
                self.viewModel.state.signUpPersonalInfoData.send(changeData)
            }
            .store(in: &cancellables)

    }

    private func configureAddOserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(activationNextButton), name: NSNotification.Name("ActivationNext"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadLocation), name: NSNotification.Name("LocationNextActivation"), object: nil)
    }

    @objc
    func loadLocation(_ notification: NSNotification) {
        let select = notification.object as? String ?? ""
        
        locationSelectView.locationSelected(select)
        view.layoutIfNeeded()

    }

    func scroll() {
        self.scrollView.setContentOffset(CGPoint.zero, animated: true)
    }

    private func configureLayout() {
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 83).isActive = true

        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: nextButton.topAnchor)
        ])
        scrollView.addSubview(signupInfoLabel)
        signupInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signupInfoLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            signupInfoLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            signupInfoLabel.heightAnchor.constraint(equalToConstant: 72)
        ])
        scrollView.addSubview(progressView)
        progressView.topAnchor.constraint(equalTo: signupInfoLabel.bottomAnchor, constant: 21).isActive = true
        progressView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        progressView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 77).isActive = true

        scrollView.addSubview(darkSpacingLineView)
        darkSpacingLineView.translatesAutoresizingMaskIntoConstraints = false
        darkSpacingLineView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        darkSpacingLineView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        darkSpacingLineView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        darkSpacingLineView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 20).isActive = true
        darkSpacingLineView.heightAnchor.constraint(equalToConstant: 8).isActive = true

        scrollView.addSubview(nickNameView)
        nickNameView.translatesAutoresizingMaskIntoConstraints = false

        nickNameView.topAnchor.constraint(equalTo: darkSpacingLineView.bottomAnchor).isActive = true
        nickNameView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        nickNameView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        nickNameView.heightAnchor.constraint(equalToConstant: 92).isActive = true

        scrollView.addSubview(locationSelectView)
        locationSelectView.translatesAutoresizingMaskIntoConstraints = false
        locationSelectView.topAnchor.constraint(equalTo: nickNameView.bottomAnchor, constant: 30).isActive = true
        locationSelectView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        locationSelectView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        locationSelectView.heightAnchor.constraint(equalToConstant: 117).isActive = true
        locationSelectView.configureUnderline(width: view.bounds.width)

        scrollView.addSubview(introduceView)
        introduceView.translatesAutoresizingMaskIntoConstraints = false
        defaultConstraint = [
            introduceView.topAnchor.constraint(equalTo: locationSelectView.bottomAnchor),
            introduceView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            introduceView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            introduceView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            introduceView.heightAnchor.constraint(equalToConstant: 179),
            introduceView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
        ]
        newConstraint = [
            introduceView.topAnchor.constraint(equalTo: locationSelectView.bottomAnchor, constant: 40),
            introduceView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            introduceView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            introduceView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            introduceView.heightAnchor.constraint(equalToConstant: 179),
            introduceView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(defaultConstraint)
    }

    private func keyBoardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func keyBoardDismiss() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }

    @objc
    func tapAction(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @objc
    func keyBoardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height, right: 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
        let point = CGPoint(x: 0, y: keyboardFrame.size.height+30)
        scrollView.setContentOffset(point, animated: true)
    }

    @objc
    func keyBoardWillHide(notification: Notification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }

}

extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
}

extension PersonalInformationViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
