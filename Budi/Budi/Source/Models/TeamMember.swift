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
    let position: TeamMemberPosition
}

struct TeamMemberPosition: Codable {
    let position: String
    let colorCode: Int
}
