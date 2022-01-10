//
//  UIView+addCornerRadius.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/08.
//

import UIKit

extension UIView {
    func addCornerRadius(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
