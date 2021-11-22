//
//  Post.swift
//  Budi
//
//  Created by 최동규 on 2021/11/10.
//

import Foundation
import Moya

struct PostResponse: Decodable {
    let statusCode: Int
    let message: String
    let data: PostContainer
}

// MARK: - DataClass
struct PostContainer: Decodable {
    let content: [Post]
    let pageable: PostPageable
    let totalPages, totalElements: Int
    let last: Bool
    let number: Int
    let size, numberOfElements: Int
    let first, empty: Bool
}

struct Post: Decodable {
    let postID: Int
    let imageUrls: [String]
    let title: String
    let category: String
    let region: String
    let description: String
    let viewCount: Int
    let postStatus: String
    let ownerID: Int
    let recruitingStatusResponses: [RecruitingStatusResponse]
    let startDate: Date
    let endDate: Date
    let createdDate: Date
    let modifiedDate: Date

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case imageUrls
        case title
        case category
        case region
        case description
        case viewCount
        case postStatus
        case ownerID = "ownerId"
        case recruitingStatusResponses
        case startDateString = "possibleStartYmdt"
        case endDateString = "possibleEndYmdt"
        case createdDateString = "createdAt"
        case modifiedDateString = "modifiedAt"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        postID = (try? container.decode(Int.self, forKey: .postID)) ?? -1
        imageUrls = (try? container.decode([String].self, forKey: .imageUrls)) ?? []
        title = (try? container.decode(String.self, forKey: .title)) ?? ""
        category = (try? container.decode(String.self, forKey: .category)) ?? ""

        let startDateString = (try? container.decode(String.self, forKey: .startDateString)) ?? ""
        startDate = startDateString.date() ?? Date(timeIntervalSince1970: 0)

        let endDateString = (try? container.decode(String.self, forKey: .endDateString)) ?? ""
        endDate = endDateString.date() ?? Date(timeIntervalSince1970: 0)

        region = (try? container.decode(String.self, forKey: .region)) ?? ""
        postStatus = (try? container.decode(String.self, forKey: .postStatus)) ?? ""
        description = (try? container.decode(String.self, forKey: .description)) ?? ""
        viewCount = (try? container.decode(Int.self, forKey: .viewCount)) ?? -1
        ownerID = (try? container.decode(Int.self, forKey: .ownerID)) ?? -1

        let createdDateString = (try? container.decode(String.self, forKey: .createdDateString)) ?? ""
        createdDate = createdDateString.date() ?? Date(timeIntervalSince1970: 0)

        let modifiedDateString = (try? container.decode(String.self, forKey: .modifiedDateString)) ?? ""
        modifiedDate = modifiedDateString.date() ?? Date(timeIntervalSince1970: 0)

        recruitingStatusResponses = (try? container.decode([RecruitingStatusResponse].self, forKey: .recruitingStatusResponses)) ?? []
    }

    init() {
        self.postID = -1
        self.imageUrls = []
        self.title = ""
        self.category = ""
        self.startDate = Date()
        self.endDate = Date()
        self.region = ""
        self.postStatus = ""
        self.description = ""
        self.viewCount = 0
        self.ownerID = 0
        self.createdDate = Date()
        self.modifiedDate = Date()
        self.recruitingStatusResponses = []
    }
}

// MARK: - RecruitingStatusResponse
struct RecruitingStatusResponse: Codable {
    let positionName, skillName: String
    let status: String
}
// MARK: - Pageable
struct PostPageable: Codable {
    let offset, pageNumber, pageSize: Int
    let paged, unpaged: Bool
}
