//
//  TeamMember.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/15.
//

import Foundation

struct TeamMemberContainer: Codable {
    let teamMembers: [TeamMember]
}

struct TeamMember: Codable {
    let memberId: Int
    let nickName: String
    let profileImageUrl: String
    let address: String
    let position: PositionData
}

struct SearchTeamMember: Codable {
    let id: Int
    let imgURL: String?
    let nickName: String
    let address: String
    let introduce: String?
    let position: [String]
    let likeCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case imgURL = "imgUrl"
        case nickName, address, introduce, position, likeCount
    }
}
