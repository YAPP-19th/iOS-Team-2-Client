//
//  Leader.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/06.
//

import Foundation

struct Leader: Codable {
    let leaderId: Int
    let nickName: String
    let profileImageUrl: String
    let address: String
    let position: PositionData
}
