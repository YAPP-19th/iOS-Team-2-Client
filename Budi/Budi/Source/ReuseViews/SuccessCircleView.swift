//
//  SuccessCircleView.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/06.
//

import UIKit

class SuccessCircleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        let check = UIImageView()
        check.image = UIImage(systemName: "checkmark")
        check.contentMode = .scaleAspectFit
        check.tintColor = .white
        addSubview(check)
        check.translatesAutoresizingMaskIntoConstraints = false
        check.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        check.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        check.widthAnchor.constraint(equalToConstant: 16).isActive = true
        check.heightAnchor.constraint(equalToConstant: 16).isActive = true

        backgroundColor = UIColor.primary
        layer.borderWidth = 2
        layer.borderColor = UIColor.primary.cgColor
        layer.cornerRadius = 14
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
