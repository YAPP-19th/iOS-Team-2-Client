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
        label.text = "설명"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.init(white: 0, alpha: 0.7)
        return label
    }()

    private let introTextView: UITextView = {
        let textView = UITextView()
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
        configureTextView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureTextView() {
        introTextView.delegate = self
        introTextView.text = "핵심 목표와 성과, 문제를 해결한 방법이나 기술 등을 요약해주세요. 글자 제한은 최대 200자 입니다."
        introTextView.textColor = UIColor.lightGray
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
        introTextView.heightAnchor.constraint(equalToConstant: 98).isActive = true
    }
}

extension IntroduceView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "핵심 목표와 성과, 문제를 해결한 방법이나 기술 등을 요약해주세요. 글자 제한은 최대 200자 입니다."
            textView.textColor = UIColor.lightGray
        }
    }

}
