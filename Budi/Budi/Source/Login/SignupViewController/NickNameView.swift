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
        label.font = UIFont.systemFont(ofSize: 13)

        return label
    }()

    private let nickNameTextField: UITextField = {
        let textField = UITextField()
        
        return textField
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLayout() {
        addSubview(nickNameLabel)
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        nickNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        nickNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true

        addSubview(nickNameTextField)
        nickNameTextField.translatesAutoresizingMaskIntoConstraints = false
        nickNameTextField.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 5).isActive = true
        nickNameTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        nickNameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        nickNameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        nickNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
