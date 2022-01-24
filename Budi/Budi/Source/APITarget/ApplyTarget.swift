//
//  ApplyTarget.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/22.
//

import Moya

// MARK: - applies: 지원자 조회, apply: 지원하기
enum ApplyTarget {
    case applies(accessToken: String, position: String, postId: Int)
    case apply(accessToken: String, param: ApplyRequest)
    case acceptApply(accessToken: String, applyId: Int)
}

extension ApplyTarget: TargetType {
    var baseURL: URL {
        return URL(string: .baseURLString)!
    }
    
    var path: String {
        switch self {
        case .applies: return "/applies"
        case .apply: return "/applies"
        case .acceptApply(_, let applyId): return "/applies/\(applyId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .apply: return .post
        case .acceptApply: return .patch
        default: return .get
        }
    }
    
    var task: Task {
        switch self {
        case .applies(_, let position, let postId): return .requestParameters(parameters: ["position": position, "postId": postId], encoding: URLEncoding.default)
        case .apply(_, let param): return .requestJSONEncodable(param)
        case .acceptApply(_, let applyId): return .requestJSONEncodable(AcceptApplyRequest(applyId: applyId))
        default: return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .applies(let accessToken, _, _), .apply(let accessToken, _), .acceptApply(let accessToken, _):
            return ["Content-Type": "application/json", "accessToken": "\(accessToken)"]
        }
    }

    var validationType: ValidationType {
      return .successCodes
    }

}
