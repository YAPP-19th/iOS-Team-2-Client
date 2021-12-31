//
//  MemberTarget.swift
//  Budi
//
//  Created by 최동규 on 2021/12/31.
//

import Moya

enum MemberTarget {
    case memberDetails(accessToken: String, id: Int)
    case memberList(postion: Position)
}

extension MemberTarget: TargetType {
    var baseURL: URL {
        return URL(string: .baseURLString)!
    }

    var path: String {
        switch self {
        case .memberDetails(_, let id): return "/api/v1/members/budiDetails/\(id)"
        case .memberList(let postion): return "/api/v1/members/budiLists/\(postion.englishStringValue)"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        return .requestPlain
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
