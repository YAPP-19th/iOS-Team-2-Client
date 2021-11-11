//
//  BackgroundView.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/11.
//

import UIKit

class BackgroundView: UIView {

    static let instanceBackground = BackgroundView()

    private let blackBackgoundView: UIView = {
        let blackBackgoundView = UIView()
        blackBackgoundView.backgroundColor = UIColor.black
        blackBackgoundView.alpha = 0.5

        return blackBackgoundView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLayout() {
        addSubview(blackBackgoundView)
        blackBackgoundView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            blackBackgoundView.topAnchor.constraint(equalTo: self.topAnchor),
            blackBackgoundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blackBackgoundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            blackBackgoundView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

}
