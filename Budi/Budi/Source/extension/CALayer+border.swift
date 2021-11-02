//
//  CALayer+border.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/03.
//

import UIKit

extension CALayer {
    func addTopBorder(color: UIColor = UIColor(named: "LightGray") ?? .systemGroupedBackground, borderWidth: CGFloat = 0.5) {
        let border = CALayer()
        border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: borderWidth)
        border.backgroundColor = color.cgColor
        addSublayer(border)
    }
}
