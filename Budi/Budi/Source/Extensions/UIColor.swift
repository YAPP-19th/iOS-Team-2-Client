//
//  SystemColor.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/11.
//

import UIKit

extension UIColor {
    // MARK: - Primary
    static var primary: UIColor {
        UIColor(red: 94/255, green: 95/255, blue: 219/255, alpha: 1)
    }
    static var primarySub: UIColor {
        UIColor(red: 236/255, green: 237/255, blue: 250/255, alpha: 1)
    }
    static var primaryVariant: UIColor {
        UIColor(red: 67/255, green: 68/255, blue: 191/255, alpha: 1)
    }
    
    // MARK: - Text
    static var textHigh: UIColor {
        UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
    }
    static var textMedium: UIColor {
        UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
    }
    static var textDisabled: UIColor {
        UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1)
    }
    
    // MARK: - Color
    static var border: UIColor {
        UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
    }
    static var white: UIColor {
        UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    }
    static var background: UIColor {
        UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
    }
    
    // MARK: - Status
    static var warning: UIColor {
        UIColor(red: 218/255, green: 30/255, blue: 40/255, alpha: 1)
    }
    static var ok: UIColor {
        UIColor(red: 0/255, green: 117/255, blue: 255/255, alpha: 1)
    }

    // MARK: - Job
    static var jobDeV: UIColor {
        UIColor(red: 51/255, green: 130/255, blue: 224/255, alpha: 1)
    }
    static var jobDevSub: UIColor {
        UIColor(red: 231/255, green: 241/255, blue: 251/255, alpha: 1)
    }
    static var jobDesign: UIColor {
        UIColor(red: 233/255, green: 98/255, blue: 98/255, alpha: 1)
    }
    static var jobDesignSub: UIColor {
        UIColor(red: 254/255, green: 237/255, blue: 237/255, alpha: 1)
    }
    static var jobPlan: UIColor {
        UIColor(red: 64/255, green: 193/255, blue: 162/255, alpha: 1)
    }
    static var jobPlanSub: UIColor {
        UIColor(red: 232/255, green: 248/255, blue: 245/255, alpha: 1)
    }

    convenience init?(hexString: String) {
        var hex = hexString
        if hex.first == "#" {
            hex.removeFirst()
        }

        var hexValue: UInt32 = 0
        guard Scanner(string: hex).scanHexInt32(&hexValue) else {
            return nil
        }

        let r, g, b, a, divisor: CGFloat

        if hex.count == 6 {
            divisor = 255
            r = CGFloat((hexValue & 0xFF0000) >> 16) / divisor
            g = CGFloat((hexValue & 0x00FF00) >> 8) / divisor
            b = CGFloat( hexValue & 0x0000FF) / divisor
            a = 1
        } else if hex.count == 8 {
            divisor = 255
            a = CGFloat((hexValue & 0xFF000000) >> 24) / divisor
            r = CGFloat((hexValue & 0x00FF00) >> 16) / divisor
            g = CGFloat((hexValue & 0x00FF00) >> 8) / divisor
            b = CGFloat((hexValue & 0x0000FF)) / divisor
        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

// MARK: - Old Color
extension UIColor {
    static var budiGreen: UIColor {
        UIColor(red: 0.41, green: 0.86, blue: 0.67, alpha: 1)
    }

    static var budiLightGreen: UIColor {
        UIColor(red: 0.701, green: 0.882, blue: 0.803, alpha: 1)
    }
    
    static var budiBackgroundGreen: UIColor {
        UIColor(red: 0.941, green: 0.984, blue: 0.968, alpha: 1)
    }

    static var budiRed: UIColor {
        UIColor(red: 0.85, green: 0.12, blue: 0.16, alpha: 1)
    }

    static var budiBlack: UIColor {
        UIColor(red: 0.117, green: 0.117, blue: 0.117, alpha: 1)
    }

    static var budiDarkGray: UIColor {
        UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
    }

    static var budiGray: UIColor {
        UIColor(red: 0.556, green: 0.556, blue: 0.556, alpha: 1)
    }

    static var budiLightGray: UIColor {
        UIColor(red: 0.866, green: 0.866, blue: 0.866, alpha: 1)
    }
    
    static var budiWhite: UIColor {
        UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    static var budiTransparentDarkGray: UIColor {
        UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    }
    
    static var budiTransparentGray: UIColor {
        UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
    }
}
