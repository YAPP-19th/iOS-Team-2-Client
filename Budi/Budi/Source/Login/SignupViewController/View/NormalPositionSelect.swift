//
//  NormalPositionSelect.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/07.
//

import UIKit

class NormalPositionSelect: UIView {
    private var selectIndex: Int = 0
    private let selectButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.imageView?.tintColor = UIColor.lightGray
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.titleLabel?.textAlignment = .center
        button.imageView?.contentMode = .scaleAspectFill
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(56/2), bottom: -20, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 56/4, bottom: 20, right: 0)
        button.addTarget(self, action: #selector(PositionViewController.normalPositionButtonAction), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setPosition(image: String, name: String, index: Int) {
        selectButton.setImage(UIImage(systemName: image), for: .normal)
        selectButton.setTitle(name, for: .normal)
        selectButton.tag = index
    }

    private func configureLayout() {
        addSubview(selectButton)
        selectButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            selectButton.topAnchor.constraint(equalTo: self.topAnchor),
            selectButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            selectButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            selectButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

}
