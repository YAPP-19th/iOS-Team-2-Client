//
//  PostTarget.swift
//  Budi
//
//  Created by 최동규 on 2021/11/22.
//

import Moya

enum BudiTarget {
    case posts
    case createPost(accessToken: String, param: PostRequest)
    case post(id: Int)
    case teamMembers(id: Int)
    case recruitingStatuses(id: Int)
    case postDefaultImageUrls
    case applies(accessToken: String, param: AppliesRequest)
    case detailPositions(postion: Position)
}

extension BudiTarget: TargetType {
    var baseURL: URL {
        return URL(string: .baseURLString)!
    }

    var path: String {
        switch self {
        case .posts, .createPost: return "/posts"
        case .post(let id): return "/posts/\(id)"
        case .teamMembers(let id): return "/posts/\(id)/members"
        case .recruitingStatuses(let id): return "/posts/\(id)/recruitingStatus"
        case .postDefaultImageUrls: return "/infos/postDefaultImageUrls"
        case .applies: return "/applies"
        case .posts: return "/posts"
        case .detailPositions: return "/infos/positions"
        }
    }

    var method: Moya.Method {
        switch self {
        case .posts, .post, .teamMembers, .recruitingStatuses, .postDefaultImageUrls: return .get
        case .createPost, .applies: return .post
        }
    }

    var task: Task {
        switch self {
        case .post, .posts, .teamMembers, .recruitingStatuses, .postDefaultImageUrls: return .requestPlain
        case .createPost(_, let param): return .requestJSONEncodable(param)
        case .applies(_, let param): return .requestJSONEncodable(param)
        case .detailPositions(let position):
            return .requestParameters(parameters: ["position": position.stringValue], encoding: URLEncoding.default)
        default: return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .posts, .post, .teamMembers, .recruitingStatuses, .postDefaultImageUrls: return ["Content-Type": "application/json"]
        case .createPost(let accessToken, _), .applies(let accessToken, _):
            return ["Content-Type": "application/json", "accessToken": "\(accessToken)"]
        }
    }

    var validationType: ValidationType {
      return .successCodes
    }
}
