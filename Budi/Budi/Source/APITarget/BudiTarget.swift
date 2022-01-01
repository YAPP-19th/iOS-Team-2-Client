//
//  PostTarget.swift
//  Budi
//
//  Created by 최동규 on 2021/11/22.
//

import Moya

enum BudiTarget {
    case posts(page: Int = 0, size: Int = 10)
    case filteredPosts(type: Position, page: Int = 0, size: Int = 10)
    case createPost(accessToken: String, param: PostRequest)
    case post(accessToken: String, id: Int)
    case detailPositions(postion: Position)
    case createInfo(acessToken: String, param: CreateInfo)
    case teamMembers(id: Int)
    case recruitingStatuses(id: Int)
    case postDefaultImageUrls
    case applies(accessToken: String, param: AppliesRequest)
    case checkDuplicateName(name: String)
    case postCategory
    case likePosts(accessToken: String, id: Int)
    case convertImage(param: ConvertImageRequest)
}

extension BudiTarget: TargetType {
    var baseURL: URL {
        return URL(string: .baseURLString)!
    }

    var path: String {
        switch self {
        case .posts: return "/posts"
        case .detailPositions: return "/infos/positions"
        case .createInfo: return "/members/createInfo"
        case .filteredPosts(let type, _, _): return "/posts/positions/\(type.stringValue)"
        case .createPost: return "/posts"
        case .post(_, let id): return "/posts/\(id)"
        case .teamMembers(let id): return "/posts/\(id)/members"
        case .recruitingStatuses(let id): return "/posts/\(id)/recruitingStatus"
        case .postDefaultImageUrls: return "/infos/postDefaultImageUrls"
        case .applies: return "/applies"
        case .checkDuplicateName: return "/members/checkDuplicateName"
        case .postCategory: return "/infos/postCategory"
        case .likePosts(_, let id): return "/post/\(id)/like-posts"
        case .convertImage: return "/imageUrls"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createInfo: return .post
        case .createPost: return .post
        case .applies: return .post
        case .likePosts: return .put
        case .convertImage: return .post
        default: return .get
        }
    }

    var task: Task {
        switch self {
        case .createInfo(_, let info) : return .requestJSONEncodable(info)
        case .checkDuplicateName(let name):
            return .requestParameters(parameters: ["name": name], encoding: URLEncoding.default)
        case .createPost(_, let param): return .requestJSONEncodable(param)
        case .applies(_, let param): return .requestJSONEncodable(param)
        case .posts(let page, let size):
            return .requestParameters(parameters: ["page": page, "size": size], encoding: URLEncoding.default)
        case .filteredPosts(_, let page, let size):
            return .requestParameters(parameters: ["page": page, "size": size], encoding: URLEncoding.default)
        case .detailPositions(let position):
            return .requestParameters(parameters: ["position": position.stringValue], encoding: URLEncoding.default)
        case .convertImage(let param): return .requestJSONEncodable(param)
        default: return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .createInfo(let accessToken, _), .createPost(let accessToken, _), .applies(let accessToken, _), .post(let accessToken, _), .likePosts(let accessToken, _):
            return ["Content-Type": "application/json", "accessToken": "\(accessToken)"]
        case .convertImage:
            return ["Content-type": "multipart/form-data"]
        default: return ["Content-Type": "application/json"]
        }
    }

    var validationType: ValidationType {
      return .successCodes
    }

}
