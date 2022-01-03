//
//  RecruitingPosition.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/03.
//

import Foundation

struct RecruitingPosition: Codable, Hashable {
    let positionName: String
    var recruitingNumber: Int
    
    static func == (lhs: RecruitingPosition, rhs: RecruitingPosition) -> Bool {
        lhs.positionName == rhs.positionName
    }
}
