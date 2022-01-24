//
//  ChatModels.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/09.
//

import Firebase
import FirebaseFirestoreSwift

struct ChatUser: Identifiable, Codable {
    @DocumentID var id: String?
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
    @DocumentID var id: String?
    let timestamp: Timestamp
    let text: String

    let senderId: String
    let senderUsername: String
    let senderPosition: String
    let senderProfileImageUrl: String
    
    let recipientId: String
    let recipientUsername: String
    let recipientPosition: String
    let recipientProfileImageUrl: String

    var isForApply: Bool = false
    var postId: Int = 0
    var projectTitle: String = ""
    var positionName: String = ""
}
