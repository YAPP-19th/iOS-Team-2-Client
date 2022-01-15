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
    func sendMessage(fromId senderId: Int, toId recipientId: Int, _ text: String) {
        var sender: ChatUser?

        fetchUserInfo(String(senderId)) { [weak self] user in
            guard let self = self else { return }
            sender = user
            
            self.fetchUserInfo(String(recipientId)) { [weak self] recipient in
                guard let self = self, let sender = sender else { return }
                self.sendMessage(from: sender, to: recipient, text)
            }
        }
    }
    
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
        let documentId = currentUserRef.documentID
        let oppositeUserRef = FirebaseCollection.messages.ref.document(message.recipientId).collection(message.senderId).document(documentId)
        
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
        FirebaseCollection.users.ref.document(uid).getDocument { snapshot, _ in
            guard let data = snapshot?.data(),
                  let dict = try? JSONSerialization.data(withJSONObject: data),
                  var user = try? JSONDecoder().decode(ChatUser.self, from: dict) else { return }
            user.id = uid
            completion(user)
        }
    }
}

// MARK: - Update
extension ChatManager {
    func updateUserInfo(_ uid: String, _ username: String, _ position: String, _ profileImageUrl: String) {
        let userData: [String: Any] = ["username": username,
                                       "position": position,
                                       "profileImageUrl": profileImageUrl]
        
        FirebaseCollection.users.ref.document(uid).setData(userData)
    }
    
    func updateUsername(_ uid: String, _ newUsername: String) {
        fetchUserInfo(uid) { user in
            let newUser = ChatUser(id: user.id, username: newUsername, position: user.position, profileImageUrl: user.profileImageUrl)
            self.registerUserInfo(newUser)
        }
    }
    
    func updateProfileImageUrl(_ uid: String, _ newProfileImageUrl: String) {
        fetchUserInfo(uid) { user in
            let newUser = ChatUser(id: user.id, username: user.username, position: user.position, profileImageUrl: newProfileImageUrl)
            self.registerUserInfo(newUser)
        }
    }
    
    func updatePosition(_ uid: String, _ newPosition: String) {
        fetchUserInfo(uid) { user in
            let newUser = ChatUser(id: user.id, username: user.username, position: newPosition, profileImageUrl: user.profileImageUrl)
            self.registerUserInfo(newUser)
        }
    }
}

// MARK: - Delete
extension ChatManager {
    func removeAllMessages(_ currentUid: String, _ oppositeUid: String) {
        let currentUserRef = FirebaseCollection.messages.ref.document(currentUid).collection(oppositeUid)
        let oppositeUserRef = FirebaseCollection.messages.ref.document(oppositeUid).collection(currentUid)

        let recentCurrentUserRef = FirebaseCollection.recentMessages(uid: currentUid).ref.document(oppositeUid)
        let recentOppositeUserRef = FirebaseCollection.recentMessages(uid: oppositeUid).ref.document(currentUid)
        
        currentUserRef.getDocuments { snapshot, _ in
            snapshot?.documents.forEach {
                currentUserRef.document($0.documentID).delete()
            }
        }
        oppositeUserRef.getDocuments { snapshot, _ in
            snapshot?.documents.forEach {
                currentUserRef.document($0.documentID).delete()
            }
        }

        recentCurrentUserRef.delete()
        recentOppositeUserRef.delete()
    }
}

// MARK: - Authentication
extension ChatManager {
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func loginWithEmail(_ email: String, _ password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, _ in
//            guard let user = result?.user else { return }
        }
    }
    
    func createUserWithEmail(_ email: String, _ password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, _ in
//            guard let user = result?.user else { return }
        }
    }
}
