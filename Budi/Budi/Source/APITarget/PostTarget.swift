//
//  PostTarget.swift
//  Budi
//
//  Created by 최동규 on 2021/11/22.
//

import Moya

enum PostTarget {
    case post(id: Int)
    case posts
    case recruitingStatuses(id: Int)
}

extension PostTarget: TargetType {
    var baseURL: URL {
        return URL(string: .baseURLString)!
    }

    var path: String {
        switch self {
        case .post(let id): return "/posts/\(id)"
        case .posts: return "/posts"
        case .recruitingStatuses(let id): return "/posts/\(id)/recruitingStatus"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        .requestPlain
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    var validationType: ValidationType {
      return .successCodes
    }
}
