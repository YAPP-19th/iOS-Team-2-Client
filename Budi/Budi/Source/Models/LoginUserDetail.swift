//
//  LoginUserDetail.swift
//  Budi
//
//  Created by 인병윤 on 2022/01/06.
//

import Foundation

struct LoginUserDetail: Codable {
    let id: Int
    let imageUrl: String?
    let nickName: String
    let level: String
    let positions: [String]
}


struct LoginCheckModel: Codable {
    let accessToken: String
}
