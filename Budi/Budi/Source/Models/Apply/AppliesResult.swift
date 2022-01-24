//
//  AppliesResult.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/22.
//

import Foundation

struct AppliesResult: Codable {
    let applyId: Int
    let applyer: Applyer
    let recruitingPositionResponse: recruitingPositionResponse
}

struct Applyer: Codable {
    let id: Int
    let profileImageUrl: String
    let nickName: String
    let address: String
    let position: PositionData
    let isApproved: Bool
}

struct recruitingPositionResponse: Codable {
    let id: Int
    let position: String
}
