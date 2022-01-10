//
//  MyBudiProject.swift
//  Budi
//
//  Created by 인병윤 on 2022/01/09.
//

import Foundation

struct MyBudiProject: Codable {
    let participatedPosts: [ProjectLists]
    let recruitedPosts: [ProjectLists]
}

struct ProjectLists: Codable {
    let id: Int
    let imageUrl: String
    let title: String
    let startDate: String
    let endDate: String
    let onlineInfo: String
    let category: String
    let likeCount: Int
}
