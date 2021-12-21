//
//  CALayer+addBorder.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/03.
//

import UIKit

extension CALayer {
    func addBorderTop(color: UIColor = UIColor(named: "LightGray") ?? .systemGroupedBackground, borderWidth: CGFloat = 0.5) {
        let border = CALayer()
        border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: borderWidth)
        border.backgroundColor = color.cgColor
        addSublayer(border)
    }
    
    func addBorderBottom(color: UIColor = UIColor(named: "LightGray") ?? .systemGroupedBackground, borderWidth: CGFloat = 0.5) {
        let border = CALayer()
        border.frame = CGRect.init(x: 0, y: frame.height-0.5, width: frame.width, height: borderWidth)
        border.backgroundColor = color.cgColor
        addSublayer(border)
    }
}
