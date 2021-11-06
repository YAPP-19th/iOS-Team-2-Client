//
//  SignupNormalViewController.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/06.
//

import UIKit

class SignupNormalViewController: UIViewController {

    @IBOutlet weak var signupInfoLabel: UILabel!
    private let progressView: ProgressView = {
        let progress = ProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.changeColor(index: 1)
        return progress
    }()
    
    private let nickNameView = NickNameView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }

    private func configureLayout() {
        view.addSubview(progressView)
        progressView.topAnchor.constraint(equalTo: signupInfoLabel.bottomAnchor, constant: 21).isActive = true
        progressView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 77).isActive = true
        let spacing = SpacingDarkLineView()
        view.addSubview(spacing)
        spacing.translatesAutoresizingMaskIntoConstraints = false
        spacing.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spacing.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        spacing.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        spacing.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 20).isActive = true
        spacing.heightAnchor.constraint(equalToConstant: 8).isActive = true
        let nick = NickNameView()
        view.addSubview(nick)
        nick.translatesAutoresizingMaskIntoConstraints = false

        nick.topAnchor.constraint(equalTo: spacing.bottomAnchor).isActive = true
        nick.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        nick.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        nick.heightAnchor.constraint(equalToConstant: 92).isActive = true
    }
}
