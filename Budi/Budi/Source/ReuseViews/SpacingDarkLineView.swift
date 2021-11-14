//
//  SpacingDarkLineView.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/06.
//

import UIKit

class SpacingDarkLineView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLayout() {
        backgroundColor = .black
        alpha = 0.04
    }
}
