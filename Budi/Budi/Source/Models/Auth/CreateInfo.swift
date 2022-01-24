//
//  CreateInfo.swift
//  Budi
//
//  Created by 인병윤 on 2021/12/16.
import Foundation

// MARK: - CreateInfo
struct CreateInfo: Codable {
    let basePosition: Int
    let imgUrl: String
    let careerList: [CareerList]
    let description, memberAddress, nickName: String
    let portfolioLink, positionList: [String]
    let projectList: [TList]

    enum CodingKeys: String, CodingKey {
        case basePosition, careerList
        case description
        case memberAddress, nickName, portfolioLink, positionList, projectList
        case imgUrl
    }
}

// MARK: - CareerList
struct CareerList: Codable {
    let companyName, careerListDescription, endDate: String
    let nowWorks: Bool
    let startDate, teamName: String
    let workRequestList: [TList]

    enum CodingKeys: String, CodingKey {
        case companyName
        case careerListDescription
        case endDate, nowWorks, startDate, teamName, workRequestList
    }
}

// MARK: - TList
struct TList: Codable {
    let description, endDate, name, startDate: String

    enum CodingKeys: String, CodingKey {
        case description
        case endDate, name, startDate
    }
}
