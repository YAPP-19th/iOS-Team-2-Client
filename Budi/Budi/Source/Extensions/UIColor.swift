//
//  SystemColor.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/11.
//

import UIKit

extension UIColor {
    static var budiGreen: UIColor {
        UIColor(red: 0.41, green: 0.86, blue: 0.67, alpha: 1.00)
    }

    static var budiLightGreen: UIColor {
        UIColor.budiGreen.withAlphaComponent(0.2)
    }

    static var budiRed: UIColor {
        UIColor(red: 0.85, green: 0.12, blue: 0.16, alpha: 1.00)
    }

    static var budiBlack: UIColor {
        UIColor.black.withAlphaComponent(0.87)
    }

    static var budiDarkGray: UIColor {
        UIColor.black.withAlphaComponent(0.60)
    }

    static var budiGray: UIColor {
        UIColor.black.withAlphaComponent(0.38)
    }

    static var budiLightGray: UIColor {
        UIColor.black.withAlphaComponent(0.08)
    }
}
