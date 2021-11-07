//
//  NormalPositionView.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/07.
//

import UIKit

class NormalPositionView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLayout() {

        let productManager = NormalPositionSelect()
        productManager.setPosition(image: "person.3.fill", name: "기획자", index: 2)

        addSubview(productManager)
        productManager.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            productManager.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            productManager.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            productManager.widthAnchor.constraint(equalToConstant: 56)
        ])

        let frontEnd = NormalPositionSelect()
        frontEnd.setPosition(image: "laptopcomputer", name: "프론트앤드", index: 1)

        addSubview(frontEnd)
        frontEnd.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            frontEnd.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            frontEnd.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            frontEnd.trailingAnchor.constraint(equalTo: productManager.leadingAnchor, constant: -60),
            frontEnd.widthAnchor.constraint(equalToConstant: 56),
            frontEnd.heightAnchor.constraint(equalTo: productManager.heightAnchor)
        ])

        let backEnd = NormalPositionSelect()
        backEnd.setPosition(image: "server.rack", name: "백앤드", index: 3)

        addSubview(backEnd)
        backEnd.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backEnd.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            backEnd.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            backEnd.leadingAnchor.constraint(equalTo: productManager.trailingAnchor, constant: 60),
            backEnd.widthAnchor.constraint(equalToConstant: 56),
            backEnd.heightAnchor.constraint(equalTo: productManager.heightAnchor)
        ])
    }
}
