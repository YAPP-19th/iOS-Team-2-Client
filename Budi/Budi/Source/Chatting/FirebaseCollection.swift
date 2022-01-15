//
//  FirebaseCollection.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/12.
//

import Firebase

enum FirebaseCollection {
    case users
    case messages
    case recentMessages(uid: String)

    var ref: CollectionReference {
        switch self {
        case .users: return Firestore.firestore().collection("users")
        case .messages: return Firestore.firestore().collection("messages")
        case .recentMessages(let uid): return Firestore.firestore().collection("messages").document(uid).collection("recent-messages")
        }
    }
}
