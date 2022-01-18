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
    case detailPositions(position: Position)
    case createInfo(acessToken: String, param: CreateInfo)
    case teamMembers(id: Int)
    case recruitingStatuses(id: Int)
    case postDefaultImageUrls
    case signUpStatusCheck(memberId: Int)
    case applies(accessToken: String, param: AppliesRequest)
    case checkDuplicateName(name: String)
    case postCategory
    case likePosts(accessToken: String, id: Int)
    case myLikePosts(accessToken: String)
    case getMyBudiProject(accessToken: String)
    case convertImageToURL(jpegData: Data)
}

extension BudiTarget: TargetType {
    var baseURL: URL {
        return URL(string: .baseURLString)!
    }

    var path: String {
        switch self {
        case .getMyBudiProject: return "/posts/me"
        case .signUpStatusCheck(let memberId): return "/members/budiDetails/\(memberId)"
        case .posts: return "/posts"
        case .detailPositions: return "/infos/positions"
        case .createInfo: return "/members/infos"
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
        case .myLikePosts: return "/post/like-posts"
        case .convertImageToURL: return "/imageUrls"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createInfo: return .post
        case .createPost: return .post
        case .applies: return .post
        case .likePosts: return .put
        case .convertImageToURL: return .post
        default: return .get
        }
    }

    var task: Task {
        switch self {
        case .signUpStatusCheck: return .requestParameters(parameters: ["accessToken": UserDefaults.standard.string(forKey: "accessToken") ?? ""], encoding: URLEncoding.default)
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
            return .requestParameters(parameters: ["position": position.jobStringEnglishValue], encoding: URLEncoding.default)
        case .convertImageToURL(let jpegData):
            let multipartFormData = [MultipartFormData(provider: .data(jpegData), name: "image", fileName: "image.jpeg", mimeType: "image/jpeg")]
            return .uploadMultipart(multipartFormData)
        default: return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .createInfo(let accessToken, _), .createPost(let accessToken, _), .applies(let accessToken, _), .post(let accessToken, _), .likePosts(let accessToken, _), .myLikePosts(let accessToken), .getMyBudiProject(let accessToken):
            return ["Content-Type": "application/json", "accessToken": "\(accessToken)"]
        case .convertImageToURL: return ["Content-type": "multipart/form-data"]
        default: return ["Content-Type": "application/json"]
        }
    }

    var validationType: ValidationType {
      return .successCodes
    }

}
