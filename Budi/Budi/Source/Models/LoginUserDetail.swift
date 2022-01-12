//
//  LoginUserDetail.swift
//  Budi
//
//  Created by 인병윤 on 2022/01/06.
//

import Foundation

struct LoginUserDetail: Codable {
    let id: Int
    var imgUrl: String
    var nickName: String
    var address: String
    var description: String
    let level: String
    var positions: [String]
    let likeCount: Int
    var projectList: [ProjectList]
    var portfolioList: [String]
    let isLikedFromCurrentMember: Bool
}

struct LoginCheckModel: Codable {
    let accessToken: String
}

struct ProjectList: Codable {
    let projectId: Int
    var name: String
    var startDate: String
    var endDate: String
    var description: String
}
