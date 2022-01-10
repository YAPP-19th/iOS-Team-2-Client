//
//  ChatMessage.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/09.
//

import Firebase
import FirebaseFirestore
import Foundation

struct ChatUser: Codable {
    let id: String
    let username: String
    let position: String
    let profileImageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case position
        case profileImageUrl
    }
}

struct ChatMessage: Codable {
    let id: String
    let time: String
    let text: String
    let fromUser: ChatUser
    let toUser: ChatUser
    
    // 프로젝트 수락하기 관련 정보 추가
//    let isInvitation: Bool
//    let projectName: String
}

enum ChatCollection {
    case user
    case message
    
    var key: String {
        switch self {
        case .user: return "users"
        case .message: return "messages"
        }
    }
}
