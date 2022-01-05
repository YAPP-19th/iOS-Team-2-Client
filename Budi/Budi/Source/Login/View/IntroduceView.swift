//
//  IntroduceView.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/06.
//

import UIKit

class IntroduceView: UIView {

    private let introduceLabel: UILabel = {
        let label = UILabel()
        label.text = "한줄소개"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.init(white: 0, alpha: 0.7)
        return label
    }()

    let introTextView: UITextField = {
        let textView = UITextField()
        textView.placeholder = "버디에게 나를 소개해보세요"
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.systemGray5.cgColor
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        return textView
    }()

    @objc
    func writeAction(textField: UITextView) {
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadTextView(_ text: String) {
        introTextView.text = text
    }

    private func configureLayout() {
        addSubview(introduceLabel)
        introduceLabel.translatesAutoresizingMaskIntoConstraints = false
        introduceLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        introduceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true

        addSubview(introTextView)
        introTextView.translatesAutoresizingMaskIntoConstraints = false
        introTextView.topAnchor.constraint(equalTo: introduceLabel.bottomAnchor, constant: 16).isActive = true
        introTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        introTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        introTextView.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
}

extension IntroduceView: UITextViewDelegate {}
