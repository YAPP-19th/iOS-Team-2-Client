//
//  NormalPositionView.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/07.
//

import UIKit
import Combine

class NormalPositionView: UIView {
    var cancellables = Set<AnyCancellable>()
    let developerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "DeveloperOff"), for: .normal)
        button.setImage(UIImage(named: "DeveloperOn"), for: .selected)
        button.setTitle("개발자", for: .normal)
        button.setTitle("개발자", for: .selected)
        button.setTitleColor(UIColor.textDisabled, for: .normal)
        button.setTitleColor(UIColor.primary, for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.verticalTextBelow = true
        return button
    }()

    let designerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "DesignerOff"), for: .normal)
        button.setImage(UIImage(named: "DesignerOn"), for: .selected)
        button.setTitle("디자이너", for: .normal)
        button.setTitle("디자이너", for: .selected)
        button.setTitleColor(UIColor.textDisabled, for: .normal)
        button.setTitleColor(UIColor.primary, for: .selected)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.titleLabel?.textAlignment = .center
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.verticalTextBelow = true
        return button
    }()

    let plannerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "PlannerOff"), for: .normal)
        button.setImage(UIImage(named: "PlannerOn"), for: .selected)
        button.setTitle("기획자", for: .normal)
        button.setTitle("기획자", for: .selected)
        button.setTitleColor(UIColor.textDisabled, for: .normal)
        button.setTitleColor(UIColor.primary, for: .selected)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.titleLabel?.textAlignment = .center
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.verticalTextBelow = true
        return button
    }()

    lazy var buttons = [developerButton, designerButton, plannerButton]

    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLayout() {

        stackView.addArrangedSubview(developerButton)
        stackView.addArrangedSubview(designerButton)
        stackView.addArrangedSubview(plannerButton)
        addSubview(stackView)
        stackView.spacing = 5
        developerButton.translatesAutoresizingMaskIntoConstraints = false
        designerButton.translatesAutoresizingMaskIntoConstraints = false
        plannerButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            developerButton.widthAnchor.constraint(equalToConstant: 105),
            developerButton.heightAnchor.constraint(equalToConstant: 80),
            designerButton.widthAnchor.constraint(equalToConstant: 105),
            designerButton.heightAnchor.constraint(equalToConstant: 80),
            plannerButton.widthAnchor.constraint(equalToConstant: 105),
            plannerButton.heightAnchor.constraint(equalToConstant: 80)
        ])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
