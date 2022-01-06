//
//  Post.swift
//  Budi
//
//  Created by 최동규 on 2021/11/10.
//

import Foundation
import Moya

// MARK: - DataClass
struct PostContainer: Decodable {
    let content: [Post]
    let pageable: PageData
    let totalPages, totalElements: Int
    let last: Bool
    let number: Int
    let size, numberOfElements: Int
    let first, empty: Bool
}

struct Post: Decodable {
    let postID: Int
    let imageUrl: String
    let title: String
    let category: String
    let startDate: Date
    let endDate: Date
    let region: String
    let description: String
    let viewCount: Int
    let postStatus: String
    let onlineInfo: String
    let createdDate: Date
    let modifiedDate: Date
    let leader: Leader
    var isLiked: Bool
    var likeCount: Int
    var isAlreadyApplied: Bool
    let ownerID: Int
    var positions: [PositionData]

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case imageUrl
        case title
        case category
        case startDateString = "startDate"
        case endDateString = "endDate"
        case region
        case description
        case viewCount
        case postStatus = "status"
        case onlineInfo
        case createdDateString = "createdAt"
        case modifiedDateString = "modifiedAt"
        case leader
        case isLiked
        case likeCount
        case isAlreadyApplied
        case ownerID = "ownerId"
        case positions
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        postID = (try? container.decode(Int.self, forKey: .postID)) ?? -1
        imageUrl = (try? container.decode(String.self, forKey: .imageUrl)) ?? ""
        title = (try? container.decode(String.self, forKey: .title)) ?? ""
        category = (try? container.decode(String.self, forKey: .category)) ?? ""
        
        let startDateString = (try? container.decode(String.self, forKey: .startDateString)) ?? ""
        startDate = startDateString.date() ?? Date(timeIntervalSince1970: 0)
        let endDateString = (try? container.decode(String.self, forKey: .endDateString)) ?? ""
        endDate = endDateString.date() ?? Date(timeIntervalSince1970: 0)

        region = (try? container.decode(String.self, forKey: .region)) ?? ""
        description = (try? container.decode(String.self, forKey: .description)) ?? ""
        viewCount = (try? container.decode(Int.self, forKey: .viewCount)) ?? -1
        postStatus = (try? container.decode(String.self, forKey: .postStatus)) ?? ""
        onlineInfo = (try? container.decode(String.self, forKey: .onlineInfo)) ?? ""
        
        let createdDateString = (try? container.decode(String.self, forKey: .createdDateString)) ?? ""
        createdDate = createdDateString.date() ?? Date(timeIntervalSince1970: 0)
        let modifiedDateString = (try? container.decode(String.self, forKey: .modifiedDateString)) ?? ""
        modifiedDate = modifiedDateString.date() ?? Date(timeIntervalSince1970: 0)
        
        leader = (try? container.decode(Leader.self, forKey: .leader)) ?? Leader(leaderId: 0, nickName: "", profileImageUrl: "", address: "", position: .init(position: "", colorCode: 0))
        isLiked = (try? container.decode(Bool.self, forKey: .isLiked)) ?? false
        likeCount = (try? container.decode(Int.self, forKey: .likeCount)) ?? -1
        isAlreadyApplied = (try? container.decode(Bool.self, forKey: .isAlreadyApplied)) ?? false
        
        ownerID = (try? container.decode(Int.self, forKey: .ownerID)) ?? -1
        positions = (try? container.decode([PositionData].self, forKey: .positions)) ?? []
    }

    init() {
        self.postID = -1
        self.imageUrl = ""
        self.title = ""
        self.category = ""
        self.startDate = Date()
        self.endDate = Date()
        self.region = ""
        self.description = ""
        self.viewCount = -1
        self.postStatus = ""
        self.onlineInfo = ""
        self.createdDate = Date()
        self.modifiedDate = Date()
        self.leader = Leader(leaderId: 0, nickName: "", profileImageUrl: "", address: "", position: .init(position: "", colorCode: 0))
        self.isLiked = false
        self.likeCount = -1
        self.isAlreadyApplied = false
        self.ownerID = -1
        self.positions = []
    }
}

struct PositionData: Codable {
    let position: String
    let colorCode: Int
}

// MARK: - Pageable
struct PageData: Codable {
    let pageNumber, pageSize: Int

    init() {
        pageNumber = -1
        pageSize = 0
    }
}
