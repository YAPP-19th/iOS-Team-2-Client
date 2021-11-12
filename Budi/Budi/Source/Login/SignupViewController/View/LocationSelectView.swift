//
//  LocationSelectView.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/06.
//

import UIKit

class LocationSelectView: UIView {
    private let activityLoactionLabel: UILabel = {
        let label = UILabel()
        label.text = "활동지역"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.init(white: 0, alpha: 0.7)
        return label
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)

        return label
    }()

    private let locationSelectButton: UIButton = {
        let button = UIButton()
        button.setTitle("지역 선택하기", for: .normal)
        button.setImage(UIImage(named: "locationAddButton"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(UIColor.init(white: 0.3, alpha: 1), for: .normal)
        button.backgroundColor = UIColor.budiGreen.withAlphaComponent(0.2)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(SignupNormalViewController.searchAction), for: .touchUpInside)
        return button
    }()

    private let bottomLine = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configreLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureUnderline(width: CGFloat) {
        bottomLine.frame = CGRect(x: 0, y: 35, width: width, height: 1.0)
        bottomLine.backgroundColor = UIColor.init(white: 0, alpha: 0.12).cgColor
    }

    func locationSelected(text: String) {
        locationLabel.text = text
        locationLabel.layer.addSublayer(bottomLine)
        locationLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        locationSelectButton.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
        locationSelectButton.setImage(UIImage(), for: .normal)
        locationSelectButton.setTitle("다시 선택", for: .normal)
        locationSelectButton.setTitleColor(UIColor.init(white: 0, alpha: 0.6), for: .normal)
    }

    private func configreLayout() {
        addSubview(activityLoactionLabel)
        activityLoactionLabel.translatesAutoresizingMaskIntoConstraints = false
        activityLoactionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        activityLoactionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        activityLoactionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.topAnchor.constraint(equalTo: activityLoactionLabel.bottomAnchor, constant: 7).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: activityLoactionLabel.leadingAnchor).isActive = true
        addSubview(locationSelectButton)
        locationSelectButton.translatesAutoresizingMaskIntoConstraints = false
        locationSelectButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10).isActive = true
        locationSelectButton.leadingAnchor.constraint(equalTo: activityLoactionLabel.leadingAnchor).isActive = true
        locationSelectButton.trailingAnchor.constraint(equalTo: activityLoactionLabel.trailingAnchor).isActive = true
        locationSelectButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }

}
