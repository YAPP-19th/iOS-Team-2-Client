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
    let positionName: String
    let positionCode: Int
    let status: String
}

// MARK: - RecruitingStatus로 변경됨
struct RecruitingStatusResponse: Codable {
    let positionName, skillName: String
    let status: String
}
