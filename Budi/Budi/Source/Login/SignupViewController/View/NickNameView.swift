//
//  NickNameView.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/06.
//

import UIKit

class NickNameView: UIView {

    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = UIFont.boldSystemFont(ofSize: 14)

        return label
    }()

    private let nickNameTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        textField.placeholder = "닉네임을 입력하세요"
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.addTarget(self, action: #selector(writeAction(textField:)), for: .editingChanged)
        return textField
    }()

    @objc
    func writeAction(textField: UITextField) {
        guard let empty = nickNameTextField.text?.isEmpty else { return }
        overlapCheckButton.backgroundColor = !empty ? UIColor.budiGreen : UIColor.init(white: 0, alpha: 0.12)
        overlapCheckButton.isEnabled = !empty ? true : false
    }

    private let overlapCheckButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.init(white: 0, alpha: 0.12)
        button.setTitle("중복확인", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.titleLabel?.textColor = UIColor.white
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true

        button.addTarget(self, action: #selector(checkAction), for: .touchUpInside)
        return button
    }()

    @objc
    func checkAction() {
        if nickNameTextField.text == "Asd" {
            checkTextLabel.text = "이미 존재하는 닉네임이에요! 다른 이름을 정해주세요!"
            checkTextLabel.textColor = UIColor.warningRed
        } else {
            checkTextLabel.text = "멋진 닉네임이네요! 사용해도 괜찮아요!"
            checkTextLabel.textColor = UIColor.budiGreen
        }
    }

    private var checkTextLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 13.5)

        return label
    }()
    private let bottomLine = CALayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        nickNameTextField.delegate = self
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureUnderline(width: CGFloat) {
        bottomLine.frame = CGRect(x: 0, y: 40, width: width - 32, height: 1.0)
        bottomLine.backgroundColor = UIColor.init(white: 0, alpha: 0.12).cgColor
        nickNameTextField.borderStyle = UITextField.BorderStyle.none
        nickNameTextField.layer.addSublayer(bottomLine)
        overlapCheckButton.widthAnchor.constraint(equalToConstant: (width-33) * 0.20).isActive = true
    }

    private func configureLayout() {
        addSubview(nickNameLabel)
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        nickNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        nickNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true

        addSubview(nickNameTextField)
        nickNameTextField.translatesAutoresizingMaskIntoConstraints = false
        nickNameTextField.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 5).isActive = true
        nickNameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        nickNameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -96).isActive = true
        nickNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addSubview(overlapCheckButton)
        overlapCheckButton.translatesAutoresizingMaskIntoConstraints = false
        overlapCheckButton.leadingAnchor.constraint(equalTo: nickNameTextField.trailingAnchor, constant: 5).isActive = true
        overlapCheckButton.centerYAnchor.constraint(equalTo: nickNameTextField.centerYAnchor).isActive = true

        addSubview(checkTextLabel)
        checkTextLabel.translatesAutoresizingMaskIntoConstraints = false
        checkTextLabel.topAnchor.constraint(equalTo: nickNameTextField.bottomAnchor, constant: 8).isActive = true
        checkTextLabel.leadingAnchor.constraint(equalTo: nickNameTextField.leadingAnchor).isActive = true
    }
}

extension NickNameView: UITextFieldDelegate {
}
