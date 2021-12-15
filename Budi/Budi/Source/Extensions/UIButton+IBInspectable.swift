//
//  UIButton+IBInspectable.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/15.
//

import UIKit

extension UIButton {

    @IBInspectable var verticalTextBelow: Bool {
        get {
            return true
        }
        set {
            guard newValue else { return }
            
            guard let image = self.imageView?.image, let titleLabel = self.titleLabel, let titleText = titleLabel.text else { return }
            
            let titleSize = titleText.size(withAttributes: [
                NSAttributedString.Key.font: titleLabel.font as Any
            ])
            
            let spacing: CGFloat = 8
            
            imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
            titleEdgeInsets = UIEdgeInsets(top: spacing, left: -image.size.width, bottom: -image.size.height, right: 0)
        }
    }
}
