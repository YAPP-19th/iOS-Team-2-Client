//
//  PostRequest.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/17.
//

import Foundation

struct PostRequest: Codable {
    let imageUrl: String
    let title: String
    let categoryName: String
    let startDate: Date
    let endDate: Date
    let onlineInfo: String
    let region: String
    let recruitingPositions: [RecruitingPosition]
    let description: String
    
    init(imageUrl: String, title: String, categoryName: String, startDate: Date, endDate: Date, onlineInfo: String, region: String, recruitingPositions: [RecruitingPosition], description: String) {
        self.imageUrl = imageUrl
        self.title = title
        self.categoryName = categoryName
        self.startDate = startDate
        self.endDate = endDate
        self.onlineInfo = onlineInfo
        self.region = region
        self.recruitingPositions = recruitingPositions
        self.description = description
    }
}
