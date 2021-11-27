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
        configureAlert()

    }

    private let positionLabel: UILabel = {
        let label = UILabel()
        let bold = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24)]
        let normal = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)]
        let oneString = NSMutableAttributedString(string: "프로젝트에 ", attributes: normal)
        let twoString = NSMutableAttributedString(string: " 참여하고자하는 직무", attributes: bold)
        let threeString = NSMutableAttributedString(string: "를 선택해주세요 ☺️", attributes: normal)
        oneString.append(twoString)
        oneString.append(threeString)
        label.attributedText = oneString
        label.numberOfLines = 0
        return label
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()

    private let normalPositionView = NormalPositionView()
    private let spacingDarkView = SpacingDarkLineView()

    private let normalPositionLabel: UILabel = {
        let label = UILabel()
        label.text = "직무"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.init(white: 0, alpha: 0.8)
        return label
    }()

    private let detailPositionLabel: UILabel = {
        let label = UILabel()
        label.text = "상세 직무"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.init(white: 0, alpha: 0.8)

        return label
    }()

    private let programmingLanguageLabel: UILabel = {
        let label = UILabel()
        label.text = "개발 언어"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.init(white: 0, alpha: 0.8)

        return label
    }()

    private let spacer: SpacingDarkLineView = {
        let space = SpacingDarkLineView()
        space.backgroundColor = .white

        return space
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(nextButtonActivation), name: NSNotification.Name("NextButtonActivation"), object: nil)
        nextButton.isEnabled = false
        self.addBackButton()
        configureLayout()
    }

    @objc
    func nextButtonActivation() {
        nextButton.isEnabled = true
        nextButton.backgroundColor = UIColor.budiGreen
    }

    @objc
    func positionButtionAction(sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            sender.setTitleColor(UIColor.budiGreen, for: .normal)
            sender.layer.borderColor = UIColor.budiGreen.cgColor
            UIView.animate(withDuration: 0.2, animations: {
                sender.layer.borderWidth = 2
            })
        } else {
            sender.isSelected = false
            sender.setTitleColor(UIColor.init(white: 0, alpha: 0.6), for: .normal)
            UIView.animate(withDuration: 0.2, animations: {
                sender.layer.borderWidth = 0.3
                sender.layer.borderColor = UIColor.init(white: 0, alpha: 0.6).cgColor
            })
        }
    }

    @objc
    func languageButtonAction(sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            sender.setTitleColor(UIColor.budiGreen, for: .normal)
            sender.layer.borderColor = UIColor.budiGreen.cgColor
            UIView.animate(withDuration: 0.2, animations: {
                sender.layer.borderWidth = 2
            })
        } else {
            sender.isSelected = false
            sender.setTitleColor(UIColor.init(white: 0, alpha: 0.6), for: .normal)
            UIView.animate(withDuration: 0.2, animations: {
                sender.layer.borderWidth = 0.3
                sender.layer.borderColor = UIColor.init(white: 0, alpha: 0.6).cgColor
            })
        }
        NotificationCenter.default.post(name: NSNotification.Name("NextButtonActivation"), object: nil)
    }

    @objc
    func normalPositionButtonAction(sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            sender.setTitleColor(UIColor.budiGreen, for: .normal)
        } else {
            sender.isSelected = false
            sender.setTitleColor(UIColor.lightGray, for: .normal)
        }
    }

    @objc
    func dismissAlert() {
        UIView.animate(withDuration: 0.2, animations: {
            BackgroundView.instanceBackground.alpha = 0.0
            AlertView.instanceAlert.alpha = 0.0
        }, completion: nil)

    }

    @objc
    func projectWriteAtcion() {
        // 일단 아무것도 하지 않으니 (뷰가 안만들어진듯) dismiss
        UIView.animate(withDuration: 0.2, animations: {
            BackgroundView.instanceBackground.alpha = 0.0
            AlertView.instanceAlert.alpha = 0.0
        }, completion: nil)
    }

    private func configureAlert() {
        BackgroundView.instanceBackground.alpha = 0.0
        AlertView.instanceAlert.alpha = 0.0
        AlertView.instanceAlert.showAlert(title: "프로젝트 이력을 입력하고\n 더 높은 레벨을 받아보세요!", cancelTitle: "나중에 입력하기", doneTitle: "지금 입력하기")
        view.addSubview(BackgroundView.instanceBackground)
        BackgroundView.instanceBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(AlertView.instanceAlert)
        AlertView.instanceAlert.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            BackgroundView.instanceBackground.topAnchor.constraint(equalTo: view.topAnchor),
            BackgroundView.instanceBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            BackgroundView.instanceBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            BackgroundView.instanceBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            AlertView.instanceAlert.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            AlertView.instanceAlert.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            AlertView.instanceAlert.widthAnchor.constraint(equalToConstant: 343),
            AlertView.instanceAlert.heightAnchor.constraint(equalToConstant: 208)
        ])

        UIView.animate(withDuration: 0.2, animations: {
            BackgroundView.instanceBackground.alpha = 0.5
            AlertView.instanceAlert.alpha = 1.0
        })
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

        scrollView.addSubview(positionLabel)
        positionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            positionLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            positionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            positionLabel.heightAnchor.constraint(equalToConstant: 64),
            positionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -98)
        ])

        scrollView.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: positionLabel.bottomAnchor, constant: 21),
            progressView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            progressView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 77)
        ])

        scrollView.addSubview(spacingDarkView)
        spacingDarkView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            spacingDarkView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 20),
            spacingDarkView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            spacingDarkView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            spacingDarkView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            spacingDarkView.heightAnchor.constraint(equalToConstant: 8)
        ])

        scrollView.addSubview(normalPositionLabel)
        normalPositionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            normalPositionLabel.topAnchor.constraint(equalTo: spacingDarkView.topAnchor, constant: 20),
            normalPositionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16)
        ])

        scrollView.addSubview(normalPositionView)
        normalPositionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            normalPositionView.topAnchor.constraint(equalTo: normalPositionLabel.bottomAnchor),
            normalPositionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            normalPositionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            normalPositionView.heightAnchor.constraint(equalToConstant: 150)
        ])

        scrollView.addSubview(detailPositionLabel)
        detailPositionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            detailPositionLabel.topAnchor.constraint(equalTo: normalPositionView.bottomAnchor),
            detailPositionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16)
        ])
        let detailPosition = PositionData().position
        configureDetailPosition(array: detailPosition, bottomAnchor: detailPositionLabel.bottomAnchor, index: 1)

        scrollView.addSubview(programmingLanguageLabel)
        programmingLanguageLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            programmingLanguageLabel.topAnchor.constraint(equalTo: detailPositionLabel.bottomAnchor, constant: 116),
            programmingLanguageLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16)
        ])

        let programmingLang = PositionData().language
        configureDetailPosition(array: programmingLang, bottomAnchor: programmingLanguageLabel.bottomAnchor, index: 2)

        scrollView.addSubview(spacer)
        spacer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            spacer.topAnchor.constraint(equalTo: programmingLanguageLabel.bottomAnchor, constant: 116),
            spacer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            spacer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            spacer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
        ])
    }

    private func configureDetailPosition(array: [String], bottomAnchor: NSLayoutYAxisAnchor, index: Int) {
        var startX: CGFloat = 16
        var startXTwo: CGFloat = 16
        for num in 0...array.count-1 {

            let button = UIButton()
            button.layer.borderWidth = 0.3
            button.layer.borderColor = UIColor.init(white: 0.2, alpha: 0.4).cgColor
            button.layer.cornerRadius = 5
            button.setTitle(array[num], for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitleColor(UIColor.init(white: 0, alpha: 0.6), for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            if index == 1 {
                button.addTarget(self, action: #selector(positionButtionAction), for: .touchUpInside)
            } else {
                button.addTarget(self, action: #selector(languageButtonAction), for: .touchUpInside)
            }
            button.tag = num

            if num < 4 {
                scrollView.addSubview(button)

                button.translatesAutoresizingMaskIntoConstraints = false
                button.topAnchor.constraint(equalTo: bottomAnchor, constant: 12).isActive = true
                button.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: startX).isActive = true
                button.widthAnchor.constraint(equalToConstant: button.intrinsicContentSize.width + 25).isActive = true
                button.heightAnchor.constraint(equalToConstant: 33).isActive = true
                startX += button.intrinsicContentSize.width + 33
            } else {
                scrollView.addSubview(button)

                button.translatesAutoresizingMaskIntoConstraints = false
                button.topAnchor.constraint(equalTo: bottomAnchor, constant: 53).isActive = true
                button.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: startXTwo).isActive = true
                button.widthAnchor.constraint(equalToConstant: button.intrinsicContentSize.width + 25).isActive = true
                button.heightAnchor.constraint(equalToConstant: 33).isActive = true
                startXTwo += button.intrinsicContentSize.width + 33
            }
        }
    }
}
