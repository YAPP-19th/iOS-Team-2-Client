//
//  MemberTarget.swift
//  Budi
//
//  Created by 최동규 on 2021/12/31.
//

import Moya

enum MemberTarget {
    case memberDetails(accessToken: String, id: String)
    case memberList(postion: Position, page: Int, size: Int)

    case evalutation(memberID: String)
    case reviews(memberID: String)
}

extension MemberTarget: TargetType {
    var baseURL: URL {
        return URL(string: .baseURLString)!
    }

    var path: String {
        switch self {
        case .memberDetails(_, let id): return "/members/budiDetails/\(id)"
        case .memberList(let postion, _, _): return "/members/budiLists/\(postion.englishStringValue)"
        case .evalutation:
            return "/select-reviews"
        case .reviews:
            return "/text-reviews"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        case .memberDetails(let accessToken, let id):
            return .requestPlain
        case .memberList(_, let page, let size):
            return .requestParameters(parameters: ["page": page, "size": size], encoding: URLEncoding.default)
        case .evalutation(memberID: let memberID):
            return .requestParameters(parameters: ["memberId": memberID], encoding: URLEncoding.default)
        case .reviews(memberID: let memberID):
            return .requestParameters(parameters: ["memberId": memberID], encoding: URLEncoding.default)
        }

    }

    var headers: [String: String]? {
        switch self {
        case .memberDetails(let accessToken, _):
            return ["accessToken": accessToken, "Content-Type": "application/json"]
        default: return ["Content-Type": "application/json"]
        }
    }

    var validationType: ValidationType {
      return .successCodes
    }

}
