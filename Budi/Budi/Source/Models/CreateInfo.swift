//
//  CreateInfo.swift
//  Budi
//
//  Created by 인병윤 on 2021/12/16.
import Foundation

// MARK: - CreateInfo
struct CreateInfo: Codable {
    let basePosition: Int
    let careerList: [CareerList]
    let createInfoDescription, memberAddress, nickName: String
    let portfolioLink, positionList: [String]
    let projectList: [TList]

    enum CodingKeys: String, CodingKey {
        case basePosition, careerList
        case createInfoDescription
        case memberAddress, nickName, portfolioLink, positionList, projectList
    }
}

// MARK: - CareerList
struct CareerList: Codable {
    let companyName, careerListDescription, endDate: String
    let memberID: Int
    let nowWorks: Bool
    let startDate, teamName: String
    let workRequestList: [TList]

    enum CodingKeys: String, CodingKey {
        case companyName
        case careerListDescription
        case endDate
        case memberID
        case nowWorks, startDate, teamName, workRequestList
    }
}

// MARK: - TList
struct TList: Codable {
    let tListDescription, endDate, name, startDate: String

    enum CodingKeys: String, CodingKey {
        case tListDescription
        case endDate, name, startDate
    }
}
