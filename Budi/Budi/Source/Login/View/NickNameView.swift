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
        label.textColor = UIColor.init(white: 0, alpha: 0.7)
        return label
    }()

    let nickNameTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        textField.placeholder = "닉네임을 입력하세요"
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.borderWidth = 0.5
        textField.cornerRadius = 8
        textField.borderColor = UIColor.init(white: 0, alpha: 0.12)
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

    }

    private var checkTextLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 13.5)

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        nickNameTextField.delegate = self
        configureLayout()
        configureObserver()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadNameText(_ text: String) {
        nickNameTextField.text = text
    }

    private func configureObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: nickNameTextField)
    }

    @objc
    func textDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            if let text = textField.text {

                if text.count > 30 {
                    textField.resignFirstResponder()
                }

                if text.count >= 30 {
                    let index = text.index(text.startIndex, offsetBy: 30)

                    let newString = text[text.startIndex..<index]
                    textField.text = String(newString)
                } else if text.count < 3 {
                    checkTextLabel.text = "3글자 이상으로 닉네임을 지어주세요!"
                    checkTextLabel.textColor = UIColor.budiRed
                }
            }
        }
    }

    private func configureLayout() {
        addSubview(nickNameLabel)
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        nickNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        nickNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true

        addSubview(nickNameTextField)
        nickNameTextField.translatesAutoresizingMaskIntoConstraints = false
        nickNameTextField.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 16).isActive = true
        nickNameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        nickNameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        nickNameTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true

        addSubview(checkTextLabel)
        checkTextLabel.translatesAutoresizingMaskIntoConstraints = false
        checkTextLabel.topAnchor.constraint(equalTo: nickNameTextField.bottomAnchor, constant: 8).isActive = true
        checkTextLabel.leadingAnchor.constraint(equalTo: nickNameTextField.leadingAnchor).isActive = true
    }
}

extension NickNameView: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
            guard let text = textField.text else { return }
            // 입력 다 지웠을 때 처리 추후 구현
            if text.count >= 3 {
                self.checkTextLabel.text = text == "Asd" ? "이미 존재하는 닉네임이에요! 다른 이름을 정해주세요!" : "멋진 닉네임이네요! 사용해도 괜찮아요!"
                self.checkTextLabel.textColor = text == "Asd" ? UIColor.budiRed : UIColor.budiGreen
            }

        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }

        if text.count >= 30 && range.length == 0 && range.location > 30 {
            return false
        }
        return true
    }
}
