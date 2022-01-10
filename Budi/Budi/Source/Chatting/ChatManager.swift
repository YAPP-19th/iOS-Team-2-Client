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
    
    let userA = ChatUser(id: "Yio3PM96OuRZtdhCcNJILzIQwbi1",
                         username: "유저A",
                         position: "iOS 개발자",
                         profileImageUrl: "https://budi.s3.ap-northeast-2.amazonaws.com/post_image/default/education.jpg")
    let userB = ChatUser(id: "3vUIvRoNGjVmBeX1Xr6DEawKf4U2",
                         username: "유저B",
                         position: "UX 디자이너",
                         profileImageUrl: "https://budi.s3.ap-northeast-2.amazonaws.com/post_image/default/dating.jpg")
}

// MARK: - Register Data
// 메세지: messages/현재유저id/상대유저id/
// 최신메세지: messages/현재유저id/recent-messages/상대유저id
// 유저정보: users/user.id/
extension ChatManager {
    func registerMessage(_ message: ChatMessage) {
        let messageData: [String: Any] = ["timestamp": Timestamp(date: Date()),
                                          "text": message.text,
                                          "fromUserId": message.fromUserId,
                                          "toUserId": message.toUserId]
        
        FirebaseCollection.messages.ref.document(message.fromUserId).collection(message.toUserId).document().setData(messageData)
        FirebaseCollection.messages.ref.document(message.toUserId).collection(message.fromUserId).document().setData(messageData)
        
        FirebaseCollection.recentMessages(uid: message.fromUserId).ref.document(message.fromUserId).setData(messageData)
    }
    
    func registerUserInfo(_ user: ChatUser) {
        guard let uid = user.id else { return }
        let userData: [String: Any] = ["username": user.username,
                                       "position": user.position,
                                       "profileImageUrl": user.profileImageUrl]
        
        FirebaseCollection.users.ref.document(uid).setData(userData)
    }
}

// MARK: - Fetch Data
extension ChatManager {
    func fetchUser(_ uid: String, _ completion: @escaping (ChatUser) -> Void) {
        FirebaseCollection.users.ref.document(uid).getDocument { snapshot, error in
            if let error = error { print("error: \(error.localizedDescription)") }
            guard let data = snapshot?.data(),
                  let dict = try? JSONSerialization.data(withJSONObject: data),
                  let user = try? JSONDecoder().decode(ChatUser.self, from: dict) else { return }
            completion(user)
        }
    }
    
    func fetchMessages(_ fromUid: String, _ toUid: String, _ completion: @escaping ([ChatMessage]) -> Void) {
        FirebaseCollection.messages.ref.document(fromUid).collection(toUid).getDocuments { snapshot, error in
            if let error = error { print("error: \(error.localizedDescription)") }
            
            guard let documents = snapshot?.documents else { return }
            let messages = documents.compactMap { try? $0.data(as: ChatMessage.self) }
            completion(messages)
        }
    }
    
    func fetchRecentMessages(_ uid: String, _ completion: @escaping ([ChatMessage]) -> Void) {
        FirebaseCollection.recentMessages(uid: uid).ref.getDocuments { snapshot, error in
            if let error = error { print("error: \(error.localizedDescription)") }
  
            guard let documents = snapshot?.documents else { return }
            let messages = documents.compactMap { try? $0.data(as: ChatMessage.self) }
            completion(messages)
        }
    }
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
