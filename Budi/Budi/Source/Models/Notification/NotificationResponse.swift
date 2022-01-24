//
//  NotificationResponse.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/18.
//

import Foundation

struct NotificationContainer<T: Decodable>: Decodable {
    let content: T
    let pageable: PageData
    let totalPages, totalElements: Int
    let last: Bool
    let number: Int
    let size, numberOfElements: Int
    let first, empty: Bool
}

struct NotificationResponse: Decodable {
    let id: Int
    let title: String
    let body: String
    let isRead: Bool
    let date: String
    let postId: Int
    let postImageUrl: String
    let postTitle: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
        case isRead
        case date
        case postId
        case postImageUrl
        case postTitle
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = (try? container.decode(Int.self, forKey: .id)) ?? 0
        title = (try? container.decode(String.self, forKey: .title)) ?? ""
        body = (try? container.decode(String.self, forKey: .body)) ?? ""
        isRead = (try? container.decode(Bool.self, forKey: .isRead)) ?? false
        date = (try? container.decode(String.self, forKey: .date)) ?? ""
        postId = (try? container.decode(Int.self, forKey: .postId)) ?? 0
        postImageUrl = (try? container.decode(String.self, forKey: .postImageUrl)) ?? ""
        postTitle = (try? container.decode(String.self, forKey: .postTitle)) ?? ""
    }
    
    init() {
        self.id = 0
        self.title = ""
        self.body = ""
        self.isRead = false
        self.date = ""
        self.postId = 0
        self.postImageUrl = ""
        self.postTitle = ""
    }
}
