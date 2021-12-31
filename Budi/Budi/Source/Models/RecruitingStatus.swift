//
//  RecruitingStatus.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/15.
//

import Foundation

struct RecruitingStatusContainer: Codable {
    let recruitingStatuses: [RecruitingStatus]
}

// Codable, Hashable -> Codable
struct RecruitingStatus: Codable {
    let recruitingPositionId: Int
    let positions: RecruitingPosition
    let recruitingNumber: Int
    let approvedStatus: String
    
//    static func == (lhs: RecruitingStatus, rhs: RecruitingStatus) -> Bool {
//        lhs.recruitingPositionId == rhs.recruitingPositionId
//    }
}

struct RecruitingPosition: Codable {
    let position: String
    let colorCode: Int
}
