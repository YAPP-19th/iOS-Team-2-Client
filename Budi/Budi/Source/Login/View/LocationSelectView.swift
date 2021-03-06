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

    let locationSelectButton: UIButton = {
        let button = UIButton()
        button.setTitle("지역 선택하기", for: .normal)
        button.setImage(UIImage(named: "locationAddButton"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.init(white: 0.3, alpha: 1), for: .normal)
        button.backgroundColor = UIColor.primarySub
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(PersonalInformationViewController.searchAction), for: .touchUpInside)
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
        bottomLine.frame = CGRect(x: -10, y: -5, width: width-32, height: 48)
        bottomLine.backgroundColor = .none
        bottomLine.cornerRadius = 8
        bottomLine.borderWidth = 0.5
        bottomLine.borderColor = UIColor.init(white: 0.8, alpha: 1).cgColor
    }

    func locationSelected(_ location: String) {
        locationLabel.text = location
        locationLabel.layer.addSublayer(bottomLine)
        locationLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        locationSelectButton.backgroundColor = UIColor.budiLightGray
        locationSelectButton.setImage(UIImage(), for: .normal)
        locationSelectButton.setTitle("다시 선택", for: .normal)
        locationSelectButton.setTitleColor(UIColor.budiDarkGray, for: .normal)
    }

    private func configreLayout() {
        addSubview(activityLoactionLabel)
        activityLoactionLabel.translatesAutoresizingMaskIntoConstraints = false
        activityLoactionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        activityLoactionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        activityLoactionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.topAnchor.constraint(equalTo: activityLoactionLabel.bottomAnchor, constant: 16).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: activityLoactionLabel.leadingAnchor, constant: 10).isActive = true
        addSubview(locationSelectButton)
        locationSelectButton.translatesAutoresizingMaskIntoConstraints = false
        locationSelectButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10).isActive = true
        locationSelectButton.leadingAnchor.constraint(equalTo: activityLoactionLabel.leadingAnchor).isActive = true
        locationSelectButton.trailingAnchor.constraint(equalTo: activityLoactionLabel.trailingAnchor).isActive = true
        locationSelectButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }

}
