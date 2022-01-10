//
//  Positions.swift
//  Budi
//
//  Created by 인병윤 on 2021/12/11.
//

import UIKit

enum Position: Int, CaseIterable {
    case developer = 1
    case designer
    case productManager

    var stringValue: String {
        switch self {
        case .developer: return "개발"
        case .designer: return "디자인"
        case .productManager: return "기획"
        }
    }

    var englishStringValue: String {
        switch self {
        case .developer: return "developer"
        case .designer: return "designer"
        case .productManager: return "planner"
        }
    }
    
    var jobStringEnglishValue: String {
        switch self {
        case .developer: return "developer"
        case .designer: return "designer"
        case .productManager: return "planner"
        }
    }
    
    var jobStringValue: String {
        switch self {
        case .developer: return "개발자"
        case .designer: return "디자이너"
        case .productManager: return "기획자"
        }
    }
    
    var characterImage: UIImage? {
        switch self {
        case .developer: return UIImage(named: "developer")
        case .designer: return UIImage(named: "designer")
        case .productManager: return UIImage(named: "planner")
        }
    }
    
    var characterBackgroundImage: UIImage? {
        switch self {
        case .developer: return UIImage(named: "developer_background")
        case .designer: return UIImage(named: "designer_background")
        case .productManager: return UIImage(named: "planner_background")
        }
    }
    
    var characterBackgroundGrayImage: UIImage? {
        switch self {
        case .developer: return UIImage(named: "developer_background_gray")
        case .designer: return UIImage(named: "designer_background_gray")
        case .productManager: return UIImage(named: "planner_background_gray")
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .developer: return UIImage(named: "ico_dev_lv1")
        case .designer: return UIImage(named: "ico_design_lv1")
        case .productManager: return UIImage(named: "ico_plan_lv1")
        }
    }

    var teamSearchCharacter: UIImage {
        switch self {
        case .developer:
            return #imageLiteral(resourceName: "Job_Dev")
        case .designer:
            return #imageLiteral(resourceName: "Job_Design")
        case .productManager:
            return #imageLiteral(resourceName: "Job_Planner")
        }
    }

    var integerValue: Int {
        switch self {
        case .developer:
            return 1
        case .productManager:
            return 2
        case .designer:
            return 3
        }
    }

    var labelBackgroundColor: UIColor {
        switch self {
        case .developer:
            return .init(hexString: "#E7F1FB") ?? .budiWhite
        case .productManager:
            return .init(hexString: "#E8F8F5") ?? .budiWhite
        case .designer:
            return .init(hexString: "#FEEDED") ?? .budiWhite
        }
    }

    var labelTextColor: UIColor {
        switch self {
        case .developer:
            return .init(hexString: "#3382E0") ?? .label
        case .productManager:
            return .init(hexString: "#40C1A2") ?? .label
        case .designer:
            return .init(hexString: "#E96262") ?? .label
        }
    }
}
