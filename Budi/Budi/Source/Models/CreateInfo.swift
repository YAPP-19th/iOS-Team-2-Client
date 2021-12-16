//
//  CareerList.swift
//  Budi
//
//  Created by 인병윤 on 2021/12/16.
//

import Foundation

struct CreateInfo: Codable {
    let accessToken: String
    let basePosition: Int
    let careerList: [CareerList]
    let description: String
    let memberAddress: String
    let nickName: String
    let positionList: [String]
    let projectList: [ProjectList]
}

struct CareerList: Codable {
    let description: String
    let endDate: String
    let name: String
    let startDate: String
}

struct ProjectList: Codable {
    let description: String
    let endDate: String
    let name: String
    let startDate: String
}

