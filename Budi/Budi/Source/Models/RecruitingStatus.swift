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

struct RecruitingStatus: Codable {
    let recruitingPositionId: Int
    let positions: PositionData
    let recruitingNumber: Int
    let approvedStatus: String
}
