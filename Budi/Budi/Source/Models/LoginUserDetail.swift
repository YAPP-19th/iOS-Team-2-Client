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
    let likeCount: Int
    let projectList: [ProjectList]
    let portfolioList: [String]
    let isLikedFromCurrentMember: Bool
}

struct LoginCheckModel: Codable {
    let accessToken: String
}

struct ProjectList: Codable {
    let projectId: Int
    let name: String
    let startDate: String
    let endDate: String
    let description: String
}
