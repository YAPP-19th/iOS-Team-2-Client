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
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }

    private func configureLayout() {
        view.addSubview(progressView)
        progressView.topAnchor.constraint(equalTo: signupInfoLabel.bottomAnchor, constant: 42).isActive = true
        progressView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 77).isActive = true
    }
}
