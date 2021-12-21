//
//  ModalControl.swift
//  Budi
//
//  Created by 인병윤 on 2021/12/15.
//

import Foundation

enum ModalControl {
    case career
    case project
    case portfolio

    var stringValue: String {
        switch self {
        case .career:
            return "경력"
        case .project:
            return "프로젝트 이력"
        case .portfolio:
            return "포트폴리오"
        }
    }
}
