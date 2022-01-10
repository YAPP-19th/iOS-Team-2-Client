//
//  ChatMessage.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/09.
//

import Firebase
import FirebaseFirestoreSwift

struct ChatUser: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    let username: String
    let position: String
    let profileImageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case position
        case profileImageUrl
    }
}

struct ChatMessage: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    let timestamp: Timestamp
    let text: String
    let fromUserId: String
    let toUserId: String
    
//    이후 프로젝트 수락하기 관련 프로퍼티 추가
//    let isInvitation: Bool
//    let projectName: String
}
