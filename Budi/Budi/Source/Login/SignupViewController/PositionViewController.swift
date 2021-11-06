//
//  ConfigurePositionViewController.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/07.
//

import UIKit

class PositionViewController: UIViewController {
    var coordinator: LoginCoordinator?

    override func viewDidLayoutSubviews() {
        scrollView.updateContentView()
    }

    private let progressView: ProgressView = {
        let progress = ProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.changeColor(index: 2)
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
        button.isEnabled = false
        return button
    }()

    @objc
    func nextAction() {
        print("hello")
    }

    @IBOutlet weak var positionInfoLabel: UILabel!

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
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
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: nextButton.topAnchor)
        ])

        scrollView.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            progressView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            progressView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 77)
        ])

//        scrollView.addSubview(positionInfoLabel)
//        positionInfoLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            positionInfoLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
//            positionInfoLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
//            positionInfoLabel.heightAnchor.constraint(equalToConstant: 64)
//        ])
    }
}
