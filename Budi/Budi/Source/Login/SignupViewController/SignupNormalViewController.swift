//
//  SignupNormalViewController.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/06.
//

import UIKit

class SignupNormalViewController: UIViewController {

    weak var coordinator: LoginCoordinator?

    override func viewDidLayoutSubviews() {
        scrollView.updateContentView()
    }

    let introduce = IntroduceView()
    let location = LocationSelectView()
    let nick = NickNameView()
    let spacing = SpacingDarkLineView()
    var defaultArray: [NSLayoutConstraint] = []
    var newArray: [NSLayoutConstraint] = []

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
        let locationSearch = LocationSearchViewController()
        locationSearch.navigationItem.title = "지역 선택"
        navigationController?.pushViewController(locationSearch, animated: true)
        NSLayoutConstraint.deactivate(defaultArray)
        NSLayoutConstraint.activate(newArray)
        NotificationCenter.default.post(name: NSNotification.Name("ActivationNext"), object: nil, userInfo: nil)
    }

    @objc
    func activationNextButton() {
        nextButton.isEnabled = true
        nextButton.backgroundColor = UIColor.budiGreen
    }

    @objc
    func nextAction() {
        let position = PositionViewController()
        position.navigationItem.title = "회원가입"
        navigationController?.pushViewController(position, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isEnabled = false
        self.addBackButton()
        configureAddOserver()
        configureLayout()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

    private func configureAddOserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(activationNextButton), name: NSNotification.Name("ActivationNext"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadLocation), name: NSNotification.Name("LocationNextActivation"), object: nil)
    }

    @objc
    func loadLocation(_ notification: NSNotification) {
        let select = notification.object as? String ?? ""
        location.locationSelected(text: select)

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

        scrollView.addSubview(spacing)
        spacing.translatesAutoresizingMaskIntoConstraints = false
        spacing.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        spacing.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        spacing.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        spacing.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 20).isActive = true
        spacing.heightAnchor.constraint(equalToConstant: 8).isActive = true

        scrollView.addSubview(nick)
        nick.translatesAutoresizingMaskIntoConstraints = false

        nick.topAnchor.constraint(equalTo: spacing.bottomAnchor).isActive = true
        nick.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        nick.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        nick.heightAnchor.constraint(equalToConstant: 92).isActive = true

        scrollView.addSubview(location)
        location.translatesAutoresizingMaskIntoConstraints = false
        location.topAnchor.constraint(equalTo: nick.bottomAnchor, constant: 30).isActive = true
        location.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        location.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        location.heightAnchor.constraint(equalToConstant: 117).isActive = true
        location.configureUnderline(width: view.bounds.width * 0.9)

        scrollView.addSubview(introduce)
        introduce.translatesAutoresizingMaskIntoConstraints = false
        defaultArray = [
            introduce.topAnchor.constraint(equalTo: location.bottomAnchor),
            introduce.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            introduce.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            introduce.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            introduce.heightAnchor.constraint(equalToConstant: 179),
            introduce.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
        ]
        newArray = [
            introduce.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 40),
            introduce.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            introduce.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            introduce.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            introduce.heightAnchor.constraint(equalToConstant: 179),
            introduce.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(defaultArray)
    }
}

extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
}
