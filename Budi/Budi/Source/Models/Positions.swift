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
        case .developer: return UIImage(named: "Developer")
        case .designer: return UIImage(named: "Designer")
        case .productManager: return UIImage(named: "Planner")
        }
    }
    
    var characterBackgroundImage: UIImage? {
        switch self {
        case .developer: return UIImage(named: "Developer_Background")
        case .designer: return UIImage(named: "Designer_Background")
        case .productManager: return UIImage(named: "Planner_Background")
        }
    }
    
    var characterBackgroundGrayImage: UIImage? {
        switch self {
        case .developer: return UIImage(named: "Developer_Background_Gray")
        case .designer: return UIImage(named: "Designer_Background_Gray")
        case .productManager: return UIImage(named: "Planner_Background_Gray")
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
}
