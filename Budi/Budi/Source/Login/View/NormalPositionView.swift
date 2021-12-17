//
//  NormalPositionView.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/07.
//

import UIKit

class NormalPositionView: UIView {

    let developerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "laptopcomputer"), for: .normal)
        button.setTitle("개발자", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.imageView?.tintColor = UIColor.lightGray
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.titleLabel?.textAlignment = .center
        button.imageView?.contentMode = .scaleAspectFill
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(56/2), bottom: -40, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 56/1.5, bottom: 20, right: 0)
        return button
    }()

    let designerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person.3.fill"), for: .normal)
        button.setTitle("디자이너", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.imageView?.tintColor = UIColor.lightGray
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.titleLabel?.textAlignment = .center
        button.imageView?.contentMode = .scaleAspectFill
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(56/2), bottom: -40, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 56/1.5, bottom: 20, right: 0)
        return button
    }()

    let productManagerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "server.rack"), for: .normal)
        button.setTitle("기획자", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.imageView?.tintColor = UIColor.lightGray
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.titleLabel?.textAlignment = .center
        button.imageView?.contentMode = .scaleAspectFill
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(56/2), bottom: -40, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 56/1.5, bottom: 20, right: 0)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLayout() {
        addSubview(developerButton)
        addSubview(designerButton)
        addSubview(productManagerButton)

        developerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            developerButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            developerButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            developerButton.trailingAnchor.constraint(equalTo: designerButton.leadingAnchor, constant: -16),
            developerButton.widthAnchor.constraint(equalToConstant: 100),
            developerButton.heightAnchor.constraint(equalTo: designerButton.heightAnchor)
        ])

        designerButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            designerButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            designerButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            designerButton.widthAnchor.constraint(equalToConstant: 100)
        ])

        productManagerButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            productManagerButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            productManagerButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            productManagerButton.leadingAnchor.constraint(equalTo: designerButton.trailingAnchor, constant: 16),
            productManagerButton.widthAnchor.constraint(equalToConstant: 100),
            productManagerButton.heightAnchor.constraint(equalTo: designerButton.heightAnchor)
        ])
    }
}
