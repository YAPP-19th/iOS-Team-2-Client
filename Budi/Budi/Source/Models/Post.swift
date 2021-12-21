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
    let region: String
    let description: String
    let viewCount: Int
    let postStatus: String
    let onlineInfo: String
    let ownerID: Int
    let recruitingStatusResponses: [RecruitingStatusResponse]
    let positions: [String]
    let leader: Leader
    let startDate: Date
    let endDate: Date
    let createdDate: Date
    let modifiedDate: Date

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case imageUrl
        case title
        case category
        case region
        case description
        case viewCount
        case postStatus = "status"
        case onlineInfo
        case ownerID = "ownerId"
        case recruitingStatusResponses
        case positions
        case leader
        case startDateString = "possibleStartYmdt"
        case endDateString = "possibleEndYmdt"
        case createdDateString = "createdAt"
        case modifiedDateString = "modifiedAt"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        postID = (try? container.decode(Int.self, forKey: .postID)) ?? -1
        imageUrl = (try? container.decode(String.self, forKey: .imageUrl)) ?? ""
        title = (try? container.decode(String.self, forKey: .title)) ?? ""
        category = (try? container.decode(String.self, forKey: .category)) ?? ""

        region = (try? container.decode(String.self, forKey: .region)) ?? ""
        description = (try? container.decode(String.self, forKey: .description)) ?? ""
        viewCount = (try? container.decode(Int.self, forKey: .viewCount)) ?? -1
        postStatus = (try? container.decode(String.self, forKey: .postStatus)) ?? ""
        onlineInfo = (try? container.decode(String.self, forKey: .onlineInfo)) ?? ""
        ownerID = (try? container.decode(Int.self, forKey: .ownerID)) ?? -1
        positions = (try? container.decode([String].self, forKey: .positions)) ?? []
        
        leader = (try? container.decode(Leader.self, forKey: .leader)) ?? Leader(leaderId: 0, nickName: "닉네임", profileImageUrl: "", address: "서울시 서초구")
        
        recruitingStatusResponses = (try? container.decode([RecruitingStatusResponse].self, forKey: .recruitingStatusResponses)) ?? []
        
        let startDateString = (try? container.decode(String.self, forKey: .startDateString)) ?? ""
        startDate = startDateString.date() ?? Date(timeIntervalSince1970: 0)

        let endDateString = (try? container.decode(String.self, forKey: .endDateString)) ?? ""
        endDate = endDateString.date() ?? Date(timeIntervalSince1970: 0)

        let createdDateString = (try? container.decode(String.self, forKey: .createdDateString)) ?? ""
        createdDate = createdDateString.date() ?? Date(timeIntervalSince1970: 0)

        let modifiedDateString = (try? container.decode(String.self, forKey: .modifiedDateString)) ?? ""
        modifiedDate = modifiedDateString.date() ?? Date(timeIntervalSince1970: 0)
    }

    init() {
        self.postID = -1
        self.imageUrl = ""
        self.title = ""
        self.category = ""
        self.startDate = Date()
        self.endDate = Date()
        self.region = ""
        self.postStatus = ""
        self.onlineInfo = ""
        self.description = ""
        self.viewCount = 0
        self.ownerID = 0
        self.positions = [""]
        self.leader = Leader(leaderId: 0, nickName: "", profileImageUrl: "", address: "")
        self.createdDate = Date()
        self.modifiedDate = Date()
        self.recruitingStatusResponses = []
    }
}

// MARK: - Leader
struct Leader: Codable {
    let leaderId: Int
    let nickName: String
    let profileImageUrl: String?
    let address: String?
}

// MARK: - Pageable
struct PageData: Codable {
    let pageNumber, pageSize: Int

    init() {
        pageNumber = -1
        pageSize = 0
    }
}
