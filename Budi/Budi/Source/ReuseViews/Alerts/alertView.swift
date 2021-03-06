//
//  AleartView.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/07.
//

import UIKit

final class AlertView: UIView {

    private let alertImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LoginAlert")
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    let cancelButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 153, height: 48))
        button.setTitle("나중에 입력하기", for: .normal)
        button.setTitleColor(UIColor.init(white: 0, alpha: 0.38), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(PositionViewController.dismissAlert), for: .touchUpInside)
        button.addTarget(self, action: #selector(LocationSearchViewController.dismissAlert), for: .touchUpInside)
        return button
    }()

    let doneButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 153, height: 48))
        button.setTitle("지금 입력하기", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(UIColor.init(white: 1, alpha: 1), for: .normal)
        button.backgroundColor = UIColor.primary
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(LocationSearchViewController.projectWriteAtcion), for: .touchUpInside)
        return button
    }()

    let xmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.imageView?.tintColor = .black
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(PositionViewController.dismissAlert), for: .touchUpInside)
        button.addTarget(self, action: #selector(LocationSearchViewController.dismissAlert), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        self.layer.cornerRadius = 16
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLayout() {

        addSubview(xmarkButton)
        addSubview(titleLabel)
        addSubview(cancelButton)
        addSubview(doneButton)
        addSubview(alertImageView)

        xmarkButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            xmarkButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            xmarkButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])

        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: alertImageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 55),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -55)
        ])

        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 8),
            cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            cancelButton.heightAnchor.constraint(equalToConstant: 46)
        ])

        doneButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            doneButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            doneButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            doneButton.heightAnchor.constraint(equalToConstant: 46)
        ])

        alertImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            alertImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
            alertImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            alertImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            alertImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 4)
        ])
    }

    func showAlert(title: String, cancelTitle: String, doneTitle: String) {
        self.titleLabel.text = title
        self.cancelButton.setTitle(cancelTitle, for: .normal)
        self.cancelButton.setTitleColor(UIColor.init(white: 0, alpha: 0.38), for: .normal)
        self.doneButton.setTitle(doneTitle, for: .normal)
        self.doneButton.setTitleColor(UIColor.white, for: .normal)
    }
}
