//
//  ErrorMessage.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/07.
//

import UIKit

enum ErrorMessage {
    case defaultMessage
    case isAlreadyApplied
    
    var stringValue: String {
        switch self {
        case .defaultMessage: return "오류가 발생했습니다\n잠시 후 다시 시도해주세요"
        case .isAlreadyApplied: return "이미 지원한 프로젝트예요!"
        }
    }
    
    var backgroundImage: UIImage? {
        switch self {
        case .defaultMessage: return UIImage(named: "bg_error")
        case .isAlreadyApplied: return UIImage(named: "bg_error_isAlreadyApplied")
        }
    }
}
