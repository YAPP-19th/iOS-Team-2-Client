//
//  ChatMessage.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/09.
//

//import FirebaseFirestoreSwift
//import Firebase
import Foundation

struct ChatUser: Decodable {
    let id: String // @DocumentID var id: String?
    let username: String
    let position: String
    let profileImageUrl: String
}

struct ChatMessage: Decodable {
    let id: String
    let time: String // Timestamp
    let fromId: String
    let toId: String
    let text: String
}
