//
//  LoginSelectViewController.swift
//  Budi
//
//  Created by ITlearning on 2021/11/02.
//

import UIKit
import NaverThirdPartyLogin
import AuthenticationServices
import Combine
import CombineCocoa

class LoginSelectViewController: UIViewController  {

    weak var coordinator: LoginCoordinator?
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    let appleAuthButton = ASAuthorizationAppleIDButton(type: .continue, style: .black)

    private let budiLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BudiLogo")
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private let helloLabel: UILabel = {
        let label = UILabel()

        label.text = "버디를 통해 나라는 싹을 틔워보세요!"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center

        return label
    }()

    private let naverLoginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("네이버 계정으로 계속하기", for: .normal)
        button.setBackgroundImage(UIImage(named: "naverLogin"), for: .normal)
        button.setTitleColor(UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.00), for: .normal)
        button.titleLabel?.textAlignment = .center
        button.semanticContentAttribute = .forceLeftToRight
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 33, bottom: 0, right: 0)
        button.backgroundColor = UIColor.white
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
        setPublisher()
    }

    private func setPublisher() {
        appleAuthButton.addTarget(self, action: #selector(appleLoginAction), for: .touchUpInside)
    }

    @objc
    func appleLoginAction(_ sender: ASAuthorizationAppleIDButton) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    private func configureLayout() {

        view.addSubview(budiLogoImageView)
        budiLogoImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            budiLogoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            budiLogoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            budiLogoImageView.widthAnchor.constraint(equalToConstant: 44.2),
            budiLogoImageView.heightAnchor.constraint(equalToConstant: 60)
        ])

        view.addSubview(privacyButton)
        privacyButton.translatesAutoresizingMaskIntoConstraints = false

        privacyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        privacyButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true

        view.addSubview(naverLoginButton)
        naverLoginButton.translatesAutoresizingMaskIntoConstraints = false
        naverLoginButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        naverLoginButton.bottomAnchor.constraint(equalTo: privacyButton.topAnchor, constant: -10).isActive = true
        naverLoginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
        naverLoginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        naverLoginButton.heightAnchor.constraint(equalToConstant: 48).isActive = true

        view.addSubview(appleAuthButton)
        appleAuthButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            appleAuthButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            appleAuthButton.bottomAnchor.constraint(equalTo: naverLoginButton.topAnchor, constant: -10),
            appleAuthButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            appleAuthButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            appleAuthButton.heightAnchor.constraint(equalToConstant: 48)
        ])

    }
}

extension LoginSelectViewController: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }

        if !isValidAccessToken {
            return
        }

//        guard let tokenType = loginInstance?.tokenType else { return }
//        guard let accessToken = loginInstance?.accessToken else { return }
//        let urlStr = "https://openapi.naver.com/v1/nid/me"
//
//        guard let url = URL(string: urlStr) else { return }
//        let auth = "\(tokenType) \(accessToken)"
//        var request = URLRequest(url: url)
//        request.setValue(auth, forHTTPHeaderField: "Authorization")
//
//        URLSession.shared.dataTaskPublisher(for: request)
//            .subscribe(on: DispatchQueue.global(qos: .background))
//            .receive(on: DispatchQueue.main)
//            .tryMap { data, response -> Data in
//                guard
//                    let response = response as? HTTPURLResponse,
//                    response.statusCode < 400 else { throw URLError(.badServerResponse) }
//                return data
//            }
//            .decode(type: Response.self, decoder: JSONDecoder())
//            .sink(receiveCompletion: { [weak self] completion in
//                guard case let .failure(error) = completion else { return }
//                print(error)
//                self?.state.loginUserInfo.send(nil)
//            }, receiveValue: { [weak self] posts in
//                print()
//                DispatchQueue.main.async {
//        coordinator?.showSignupNormalViewController(userLogininfo: info)
//                    coordinator?.showSignupNormalViewController()
//                }
//
//                self?.state.loginUserInfo.send(posts.response)
//            })
//            .store(in: &self.cancellables)


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
extension LoginSelectViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        let credential = authorization.credential as? ASAuthorizationAppleIDCredential
        guard
              let hashcode = credential?.user else { return }
        let info = LoginUserInfo(nickname: nil, email: nil, name: nil, id: hashcode)
        coordinator?.showSignupNormalViewController(userLogininfo: info)
    }

    func LoginSelectViewController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let alertController = UIAlertController(title: "로그인 실패!\n\(error.localizedDescription)",
                                                message: nil,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension LoginSelectViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window ?? ASPresentationAnchor()
    }
}
