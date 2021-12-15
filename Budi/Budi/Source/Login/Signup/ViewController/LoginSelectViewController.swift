//
//  LoginSelectViewController.swift
//  Budi
//
//  Created by ITlearning on 2021/11/02.
//

import UIKit
import NaverThirdPartyLogin
class LoginSelectViewController: UIViewController {

    weak var coordinator: LoginCoordinator?
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    private let helloLabel: UILabel = {
        let label = UILabel()

        label.text = "버디를 통해 나라는 싹을 틔워보세요!"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center

        return label
    }()

    private let naverLoginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "naverImage"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("네이버 계정으로 계속하기", for: .normal)
        button.titleLabel?.textAlignment = .left
        button.imageView?.contentMode = .scaleAspectFit
        button.semanticContentAttribute = .forceLeftToRight
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: -30, bottom: 10, right: 0)
        button.backgroundColor = UIColor(red: 0.11, green: 0.78, blue: 0.00, alpha: 1.00)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(moveSignupAction), for: .touchUpInside)
        return button
    }()

    @objc
    func moveSignupAction() {
        loginInstance?.requestThirdPartyLogin()
    }

    private let privacyButton: UIButton = {
        let button = UIButton()
        let privacyText: String = "개인정보처리방침"
        let titleString = NSMutableAttributedString(string: privacyText)
        titleString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: privacyText.count))
        button.setAttributedTitle(titleString, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loginInstance?.delegate = self
        loginInstance?.requestDeleteToken()
        configureLayout()
    }

    private func configureLayout() {
        view.addSubview(helloLabel)
        helloLabel.translatesAutoresizingMaskIntoConstraints = false

        helloLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        helloLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        helloLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        helloLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        view.addSubview(privacyButton)
        privacyButton.translatesAutoresizingMaskIntoConstraints = false

        privacyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        privacyButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true

        view.addSubview(naverLoginButton)
        naverLoginButton.translatesAutoresizingMaskIntoConstraints = false
        naverLoginButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        naverLoginButton.bottomAnchor.constraint(equalTo: privacyButton.topAnchor, constant: -10).isActive = true
        naverLoginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        naverLoginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        naverLoginButton.heightAnchor.constraint(equalToConstant: 48).isActive = true

    }
}

extension LoginSelectViewController: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        coordinator?.showSignupNormalViewController()
    }

    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {

    }

    func oauth20ConnectionDidFinishDeleteToken() {
        loginInstance?.requestDeleteToken()
    }

    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("error: \(error.localizedDescription)")
    }

}
