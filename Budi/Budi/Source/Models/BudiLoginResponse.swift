//
//  BudiLoginResponse.swift
//  Budi
//
//  Created by 인병윤 on 2021/12/21.
//

import Foundation

struct BudiLoginResponse: Codable {
    let memberId: Int
    let userId: String
    let accessToken: String
}
