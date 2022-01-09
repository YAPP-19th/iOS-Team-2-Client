//
//  MyLikePost.swift
//  Budi
//
//  Created by 인병윤 on 2022/01/09.
//

import Foundation

struct MyLikePost: Codable {
    let content: [Content]
//    let pageable: Pageable
    let totalPages, totalElements: Int
//    let last: Bool
//    let number: Int
//    let sort: Sort
//    let size, numberOfElements: Int
//    let first, empty: Bool
}

// MARK: - Content
struct Content: Codable {
    let postId: Int
    let imageUrl: String
    let title, startDate, endDate, onlineInfo: String
    let category: String
    let likeCount: Int

    enum CodingKeys: String, CodingKey {
        case postId
        case imageUrl
        case title, startDate, endDate, onlineInfo, category, likeCount
    }
}

// MARK: - Pageable
struct Pageable: Codable {
    let sort: Sort
    let offset, pageNumber, pageSize: Int
    let paged, unpaged: Bool
}

// MARK: - Sort
struct Sort: Codable {
    let empty, sorted, unsorted: Bool
}
