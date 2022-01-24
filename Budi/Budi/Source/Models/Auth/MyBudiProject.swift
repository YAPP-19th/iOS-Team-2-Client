//
//  MyBudiProject.swift
//  Budi
//
//  Created by 인병윤 on 2022/01/09.
//

import Foundation

struct MyBudiProject: Codable {
    let participatedPosts: [MyBudiPost]
    let recruitedPosts: [MyBudiPost]
}

struct MyBudiPost: Codable {
    let id: Int
    let imageUrl: String
    let title: String
    let startDate: String
    let endDate: String
    let onlineInfo: String
    let category: String
    let likeCount: Int
}

struct PersonalProject: Codable {
    let projectId: Int
    let name: String
    let startDate: String
    let endDate: String
    let description: String

}
