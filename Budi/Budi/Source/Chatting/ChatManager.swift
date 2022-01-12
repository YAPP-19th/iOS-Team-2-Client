//
//  FirebaseManager.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/10.
//

import Firebase

final class ChatManager {
    
    static var shared = ChatManager()
    
    private init() {}
}

// MARK: - 경로
// 메세지: messages/현재유저id/상대유저id/
// 최신메세지: messages/현재유저id/recent-messages/상대유저id
// 유저정보: users/user.id/

// MARK: - Message
extension ChatManager {
    func sendMessage(from sender: ChatUser, to recipient: ChatUser, _ text: String) {
        guard let senderId = sender.id, let recipientId = recipient.id else { return }
        
        let message = ChatMessage(timestamp: Timestamp(date: Date()),
                                  text: text,
                                  senderId: senderId,
                                  senderUsername: sender.username,
                                  senderPosition: sender.position,
                                  senderProfileImageUrl: sender.profileImageUrl,
                                  recipientId: recipientId,
                                  recipientUsername: recipient.username,
                                  recipientPosition: recipient.position,
                                  recipientProfileImageUrl: recipient.profileImageUrl)
        
        registerMessage(message)
    }
    
    private func registerMessage(_ message: ChatMessage) {
        let messageData: [String: Any] = ["timestamp": message.timestamp,
                                          "text": message.text,
                                          "senderId": message.senderId,
                                          "senderUsername": message.senderUsername,
                                          "senderPosition":message.senderPosition,
                                          "senderProfileImageUrl": message.senderProfileImageUrl,
                                          "recipientId": message.recipientId,
                                          "recipientUsername": message.recipientUsername,
                                          "recipientPosition":message.senderPosition,
                                          "recipientProfileImageUrl": message.recipientProfileImageUrl]
        
        let currentUserRef = FirebaseCollection.messages.ref.document(message.senderId).collection(message.recipientId).document()
        let messageId = currentUserRef.documentID
        let oppositeUserRef = FirebaseCollection.messages.ref.document(message.senderId).collection(message.recipientId).document(messageId)
        
        let recentCurrentUserRef = FirebaseCollection.recentMessages(uid: message.senderId).ref.document(message.recipientId)
        let recentOppositeUserRef = FirebaseCollection.recentMessages(uid: message.recipientId).ref.document(message.senderId)
        
        currentUserRef.setData(messageData)
        oppositeUserRef.setData(messageData)
        
        recentCurrentUserRef.setData(messageData)
        recentOppositeUserRef.setData(messageData)
    }
}

// MARK: - User
extension ChatManager {
    func registerUserInfo(_ user: ChatUser) {
        guard let uid = user.id else { return }
        let userData: [String: Any] = ["username": user.username,
                                       "position": user.position,
                                       "profileImageUrl": user.profileImageUrl]
        
        FirebaseCollection.users.ref.document(uid).setData(userData)
    }
    
    func fetchUserInfo(_ uid: String, _ completion: @escaping (ChatUser) -> Void) {
        FirebaseCollection.users.ref.document(uid).getDocument { snapshot, error in
            if let error = error { print("error: \(error.localizedDescription)") }
            guard let data = snapshot?.data(),
                  let dict = try? JSONSerialization.data(withJSONObject: data),
                  var user = try? JSONDecoder().decode(ChatUser.self, from: dict) else { return }
            user.id = uid
            completion(user)
        }
    }
}

// MARK: - Test/Remove Collection
extension ChatManager {
//    func removeAllDocument(_ currentUid: String, _ oppositeUid: String) {
//        FirebaseCollection.users.ref.document(currentUid).delete()
//        FirebaseCollection.messages.ref.document(currentUid).delete()
//        FirebaseCollection.recentMessages(uid: currentUid).ref.document(oppositeUid).delete()
//
//        FirebaseCollection.users.ref.document(oppositeUid).delete()
//        FirebaseCollection.messages.ref.document(oppositeUid).delete()
//        FirebaseCollection.recentMessages(uid: oppositeUid).ref.document(currentUid).delete()
//    }
}

// MARK: - Authentication
extension ChatManager {
    func loginWithEmail(_ email: String, _ password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error { print("error: \(error.localizedDescription)") }
//            guard let user = result?.user else { return }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func createUserWithEmail(_ email: String, _ password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error { print("error: \(error.localizedDescription)") }
//            guard let user = result?.user else { return }
        }
    }
}
