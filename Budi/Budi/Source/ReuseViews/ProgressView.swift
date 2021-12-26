//
//  ProgressView.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/06.
//

import UIKit

class ProgressView: UIView {

    private let numberOne: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.alpha = 0.12
        return label
    }()

    private let numberTwo: UILabel = {
        let label = UILabel()
        label.text = "2"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.alpha = 0.12
        return label
    }()

    private let numberThree: UILabel = {
        let label = UILabel()
        label.text = "3"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.alpha = 0.12
        return label
    }()

    private let stepOneLabel: UILabel = {
        let label = UILabel()
        label.text = "기본정보"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
        label.alpha = 0.38

        return label
    }()

    private let stepTwoLabel: UILabel = {
        let label = UILabel()
        label.text = "상세직무"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
        label.alpha = 0.38

        return label
    }()

    private let stepThreeLabel: UILabel = {
        let label = UILabel()
        label.text = "이력관리"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
        label.alpha = 0.38

        return label
    }()

    private lazy var oneView: UIView = {
        let one = UIView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        one.addSubview(numberOne)
        numberOne.translatesAutoresizingMaskIntoConstraints = false
        numberOne.centerXAnchor.constraint(equalTo: one.centerXAnchor).isActive = true
        numberOne.centerYAnchor.constraint(equalTo: one.centerYAnchor).isActive = true
        one.translatesAutoresizingMaskIntoConstraints = false
        one.widthAnchor.constraint(equalToConstant: 28).isActive = true
        one.heightAnchor.constraint(equalToConstant: 28).isActive = true
        one.addSubview(stepOneLabel)
        stepOneLabel.translatesAutoresizingMaskIntoConstraints = false
        stepOneLabel.centerXAnchor.constraint(equalTo: one.centerXAnchor).isActive = true
        stepOneLabel.topAnchor.constraint(equalTo: numberOne.bottomAnchor, constant: 10).isActive = true
        one.backgroundColor = .white
        one.layer.borderWidth = 2
        one.layer.borderColor = UIColor.black.withAlphaComponent(0.12).cgColor
        one.layer.cornerRadius = 14
        return one
    }()

    private lazy var twoView: UIView = {
        let two = UIView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        two.addSubview(numberTwo)
        numberTwo.translatesAutoresizingMaskIntoConstraints = false
        numberTwo.centerXAnchor.constraint(equalTo: two.centerXAnchor).isActive = true
        numberTwo.centerYAnchor.constraint(equalTo: two.centerYAnchor).isActive = true
        two.translatesAutoresizingMaskIntoConstraints = false
        two.widthAnchor.constraint(equalToConstant: 28).isActive = true
        two.heightAnchor.constraint(equalToConstant: 28).isActive = true
        two.addSubview(stepTwoLabel)
        stepTwoLabel.translatesAutoresizingMaskIntoConstraints = false
        stepTwoLabel.centerXAnchor.constraint(equalTo: two.centerXAnchor).isActive = true
        stepTwoLabel.topAnchor.constraint(equalTo: numberTwo.bottomAnchor, constant: 10).isActive = true
        two.backgroundColor = .white
        two.layer.borderWidth = 2
        two.layer.borderColor = UIColor.black.withAlphaComponent(0.12).cgColor
        two.layer.cornerRadius = 14
        return two
    }()

    private lazy var threeView: UIView = {
        let three = UIView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        three.addSubview(numberThree)
        numberThree.translatesAutoresizingMaskIntoConstraints = false
        numberThree.centerXAnchor.constraint(equalTo: three.centerXAnchor).isActive = true
        numberThree.centerYAnchor.constraint(equalTo: three.centerYAnchor).isActive = true
        three.translatesAutoresizingMaskIntoConstraints = false
        three.widthAnchor.constraint(equalToConstant: 28).isActive = true
        three.heightAnchor.constraint(equalToConstant: 28).isActive = true
        three.addSubview(stepThreeLabel)
        stepThreeLabel.translatesAutoresizingMaskIntoConstraints = false
        stepThreeLabel.centerXAnchor.constraint(equalTo: three.centerXAnchor).isActive = true
        stepThreeLabel.topAnchor.constraint(equalTo: numberThree.bottomAnchor, constant: 10).isActive = true
        three.backgroundColor = .white
        three.layer.borderWidth = 2
        three.layer.borderColor = UIColor.black.withAlphaComponent(0.12).cgColor
        three.layer.cornerRadius = 14
        return three
    }()

    private let leftProgressLineView: UIView = {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.widthAnchor.constraint(equalToConstant: 102).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        lineView.backgroundColor = .black
        lineView.alpha = 0.12

        return lineView
    }()

    private let rightProgressLineView: UIView = {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.widthAnchor.constraint(equalToConstant: 102).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        lineView.backgroundColor = .black
        lineView.alpha = 0.12

        return lineView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLayout()
    }

    private func configureLayout() {
        backgroundColor = .white
        addSubview(twoView)
        twoView.translatesAutoresizingMaskIntoConstraints = false
        twoView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        twoView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        addSubview(leftProgressLineView)
        leftProgressLineView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        leftProgressLineView.trailingAnchor.constraint(equalTo: twoView.leadingAnchor).isActive = true
        addSubview(rightProgressLineView)
        rightProgressLineView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        rightProgressLineView.leadingAnchor.constraint(equalTo: twoView.trailingAnchor).isActive = true
        addSubview(oneView)
        oneView.translatesAutoresizingMaskIntoConstraints = false
        oneView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        oneView.trailingAnchor.constraint(equalTo: twoView.leadingAnchor, constant: -93).isActive = true
        addSubview(threeView)
        threeView.translatesAutoresizingMaskIntoConstraints = false
        threeView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        threeView.leadingAnchor.constraint(equalTo: twoView.trailingAnchor, constant: 93).isActive = true
    }

    func changeColor(index: Int) {
        switch index {
        case 1:
            numberOneColorSet()
        case 2:
            numberTwoColorSet()
        case 3:
            numberThreeColorSet()
        default:
            break
        }
    }

    private func numberOneColorSet() {
        numberOne.textColor = UIColor.primary
        numberOne.alpha = 1
        oneView.layer.borderColor = UIColor.primary.cgColor
        stepOneLabel.alpha = 1
    }

    private func numberTwoColorSet() {
        removeOne()
        numberTwo.textColor = UIColor.primary
        numberTwo.alpha = 1
        twoView.layer.borderColor = UIColor.primary.cgColor
        stepTwoLabel.alpha = 1
    }
    private func numberThreeColorSet() {
        removeTwo()
        numberThree.textColor = UIColor.primary
        numberThree.alpha = 1
        threeView.layer.borderColor = UIColor.primary.cgColor
        stepThreeLabel.alpha = 1
    }

    private func removeOne() {
        oneView.subviews.forEach { $0.removeFromSuperview() }
        let success = SuccessCircleView()
        oneView.addSubview(success)
        success.translatesAutoresizingMaskIntoConstraints = false
        success.centerXAnchor.constraint(equalTo: oneView.centerXAnchor).isActive = true
        success.centerYAnchor.constraint(equalTo: oneView.centerYAnchor).isActive = true
        success.widthAnchor.constraint(equalToConstant: 28).isActive = true
        success.heightAnchor.constraint(equalToConstant: 28).isActive = true
        oneView.addSubview(stepOneLabel)
        stepOneLabel.translatesAutoresizingMaskIntoConstraints = false
        stepOneLabel.centerXAnchor.constraint(equalTo: oneView.centerXAnchor).isActive = true
        stepOneLabel.topAnchor.constraint(equalTo: success.bottomAnchor, constant: 8).isActive = true
        oneView.layer.borderWidth = 0
        oneView.alpha = 1
    }

    private func removeTwo() {
        removeOne()
        twoView.subviews.forEach { $0.removeFromSuperview() }
        let twoSuccess = SuccessCircleView()
        twoView.addSubview(twoSuccess)
        twoSuccess.translatesAutoresizingMaskIntoConstraints = false
        twoSuccess.centerXAnchor.constraint(equalTo: twoView.centerXAnchor).isActive = true
        twoSuccess.centerYAnchor.constraint(equalTo: twoView.centerYAnchor).isActive = true
        twoSuccess.widthAnchor.constraint(equalToConstant: 28).isActive = true
        twoSuccess.heightAnchor.constraint(equalToConstant: 28).isActive = true
        twoView.addSubview(stepTwoLabel)
        stepTwoLabel.translatesAutoresizingMaskIntoConstraints = false
        stepTwoLabel.centerXAnchor.constraint(equalTo: twoView.centerXAnchor).isActive = true
        stepTwoLabel.topAnchor.constraint(equalTo: twoSuccess.bottomAnchor, constant: 10).isActive = true
        twoView.layer.borderWidth = 0
        twoView.alpha = 1
    }
}
