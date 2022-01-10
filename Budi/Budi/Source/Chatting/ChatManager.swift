//
//  FirebaseManager.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/10.
//

import Foundation
import Firebase
import FirebaseFirestore

final class ChatManager {
    
    static var shared = ChatManager()
    
    private init() {}
    
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
    
    // MARK: - TestUser
    let testCurrentUser = ChatUser(id: "P8ZxC4xsOceXpaZG6fA1xEG9YDP2",
                                   username: "현재 유저",
                                   position: "개발자",
                                   profileImageUrl: "https://budi.s3.ap-northeast-2.amazonaws.com/post_image/default/education.jpg")
    let testOtherUser = ChatUser(id: "9AZkIT5MloajqzmubMo7aZ5Z3kj1",
                                 username: "보내는 사람",
                                 position: "개발자",
                                 profileImageUrl: "https://budi.s3.ap-northeast-2.amazonaws.com/post_image/default/dating.jpg")
       
    // MARK: - Fetch
    func fetchUser(_ uid: String) {
        FirebaseCollection.users.ref.document(uid).getDocument { snapshot, error in
            if let error = error { print("error: \(error.localizedDescription)") }

            guard let data = snapshot?.data() else { return }
            print("user: \(data)")
        }
    }
    
    func fetchMessages(_ fromUid: String, _ toUid: String) -> [ChatMessage] {
        let messages: [ChatMessage] = []

        FirebaseCollection.messages.ref.document(fromUid).collection(toUid).getDocuments { snapshot, error in
            if let error = error { print("error: \(error.localizedDescription)") }
            
            guard let documents = snapshot?.documents else { return }
//            let messages = documents.compactMap { (document) -> ChatMessage? in
//                return try? document.data(as: ChatMessage.self)
//            }
            
            print("messages: \(documents)")
        }
        
        return messages
    }
    
    func fetchRecentMessages(_ uid: String) -> [ChatMessage] {
        let recentMessages: [ChatMessage] = []
        
        FirebaseCollection.recentMessages(uid: uid).ref.getDocuments { snapshot, error in
            if let error = error { print("error: \(error.localizedDescription)") }
            
            guard let documents = snapshot?.documents else { return }
            print("recent-messages: \(documents)")
        }
        
        return recentMessages
    }
    
    // MARK: - Register
    // 메세지: messages/현재유저id/상대유저id/
    // 최신메세지: messages/현재유저id/recent-messages/상대유저id
    func registerMessage(_ message: ChatMessage) {
        guard let messageData = message.convertToDictionary else { return }
        
        FirebaseCollection.messages.ref.document(message.fromUserId).collection(message.toUserId).document().setData(messageData)
        FirebaseCollection.messages.ref.document(message.toUserId).collection(message.fromUserId).document().setData(messageData)
        
        FirebaseCollection.recentMessages(uid: message.fromUserId).ref.document(message.fromUserId).setData(messageData)
    }
    
    // 유저정보: users/user.id/
    func registerUserInfo(_ user: ChatUser) {
        guard let userData = user.convertToDictionary else { return }
     
        FirebaseCollection.users.ref.document(user.id).setData(userData) { _ in
            print("registered user")
        }
    }
    
    func createUserWithEmail(_ email: String, _ password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error { print("error: \(error.localizedDescription)") }
                                         
            guard let user = result?.user else { return }
            print("user: \(user)")
        }
    }
    
}
