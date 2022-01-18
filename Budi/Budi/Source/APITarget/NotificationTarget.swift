//
//  NotificationTarget.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/18.
//

import Moya

enum NotificationTarget {
    case notifications(accessToken: String, page: Int = 0, size: Int = 100)
}

extension NotificationTarget: TargetType {
    
    var baseURL: URL {
        return URL(string: .baseURLString)!
    }
    
    var path: String {
        switch self {
        case .notifications: return "/notifications"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .notifications: return .get
        }
    }
    
    var task: Task {
        switch self {
        case .notifications(_, let page, let size):
            return .requestParameters(parameters: ["page": page, "size": size], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .notifications(let accessToken, _, _):
            return ["Content-Type": "application/json", "accessToken": "\(accessToken)"]
        }
    }

    var validationType: ValidationType {
      return .successCodes
    }
                                                                           
}
