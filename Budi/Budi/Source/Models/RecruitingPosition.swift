//
//  RecruitingPosition.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/03.
//

import Foundation

struct RecruitingPosition: Codable, Hashable {
    let position: String
    var recruitingNumber: Int
    
    static func == (lhs: RecruitingPosition, rhs: RecruitingPosition) -> Bool {
        lhs.position == rhs.position
    }
}
