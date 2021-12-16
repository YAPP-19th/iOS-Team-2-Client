//
//  PostTarget.swift
//  Budi
//
//  Created by 최동규 on 2021/11/22.
//

import Moya

enum BudiTarget {
    case post(id: Int)
    case posts
    case teamMembers(id: Int)
    case recruitingStatuses(id: Int)
    case applies(accessToken: String, param: AppliesRequest)
}

extension BudiTarget: TargetType {
    var baseURL: URL {
        return URL(string: .baseURLString)!
    }

    var path: String {
        switch self {
        case .post(let id): return "/posts/\(id)"
        case .posts: return "/posts"
        case .teamMembers(let id): return "/posts/\(id)/members"
        case .recruitingStatuses(let id): return "/posts/\(id)/recruitingStatus"
        case .applies: return "/applies"
        }
    }

    var method: Moya.Method {
        switch self {
        case .post, .posts, .teamMembers, .recruitingStatuses: return .get
        case .applies: return .post
        }
    }

    var task: Task {
        switch self {
        case .post, .posts, .teamMembers, .recruitingStatuses: return .requestPlain
        case .applies(_, let param): return .requestJSONEncodable(param)
        }
    }

    var headers: [String: String]? {
        switch self {
        case .post, .posts, .teamMembers, .recruitingStatuses: return ["Content-Type": "application/json"]
        case .applies(let accessToken, _): return ["Content-Type": "application/json",
                                                "accessToken": "\(accessToken)"]
        }
    }

    var validationType: ValidationType {
      return .successCodes
    }
}
