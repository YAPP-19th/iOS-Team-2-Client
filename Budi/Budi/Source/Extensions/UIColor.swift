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
        UIColor(red: 0.117, green: 0.117, blue: 0.117, alpha: 1.000)
    }

    static var budiDarkGray: UIColor {
        UIColor(red: 0.360, green: 0.360, blue: 0.360, alpha: 1.000)
    }

    static var budiGray: UIColor {
        UIColor(red: 0.556, green: 0.556, blue: 0.556, alpha: 1.000)
    }

    static var budiLightGray: UIColor {
        UIColor(red: 0.866, green: 0.866, blue: 0.866, alpha: 1.000)
    }
}
