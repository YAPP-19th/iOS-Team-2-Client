//
//  Positions.swift
//  Budi
//
//  Created by 인병윤 on 2021/12/11.
//

import Foundation

enum Position {
    case productManager
    case designer
    case developer

    var stringValue: String {
        switch self {
        case .productManager:
            return "기획"
        case .designer:
            return "디자인"
        case .developer:
            return "개발"
        }
    }
}
