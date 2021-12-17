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
    case detailPositions(postion: Position)
    case createInfo(acessToken: String, param: CreateInfo)
}

extension BudiTarget: TargetType {
    var baseURL: URL {
        return URL(string: .baseURLString)!
    }

    var path: String {
        switch self {
        case .post(let id): return "/posts/\(id)"
        case .posts: return "/posts"
        case .detailPositions: return "/infos/positions"
        case .createInfo: return "/members/createInfo"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createInfo:
            return .post
        default:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .detailPositions(let position):
            return .requestParameters(parameters: ["position": position.stringValue], encoding: URLEncoding.default)
        default: return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .createInfo(let accessToken, _):
            return ["accessToken": accessToken, "Content-Type": "application/json"]
        default:
            return ["Content-Type": "application/json"]
        }
    }

    var validationType: ValidationType {
      return .successCodes
    }

}
