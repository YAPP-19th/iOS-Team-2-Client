//
//  FirebaseManager.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/10.
//

import Foundation
import Firebase

final class ChatManager {
    
    static var shared = ChatManager()
    
    private init() {}
    
    enum FirebaseCollection: String {
        case users
        case messages

        var ref: CollectionReference {
            switch self {
            case .users: return Firestore.firestore().collection(self.rawValue)
            case .messages: return Firestore.firestore().collection(self.rawValue)
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
        
    func fetchUser(_ uid: String) {
        FirebaseCollection.users.ref.document(uid).getDocument { snapshot, error in
            if let error = error { print("error: \(error.localizedDescription)") }

            guard let data = snapshot?.data() else { return }
            print("user data: \(data)")
        }
    }
    
    func fetchMessages(_ uid: String) -> [ChatMessage] {
        let messages: [ChatMessage] = []
        
        FirebaseCollection.messages.ref.document(uid).getDocument { snapshot, error in
            if let error = error { print("error: \(error.localizedDescription)") }

            guard let data = snapshot?.data() else { return }
            print("messages data: \(data)")
            
        }
        
        return messages
    }
    
    func registerMessage(_ message: ChatMessage) {
        guard let messageData = message.convertToDictionary else { return }
        
        FirebaseCollection.messages.ref.document(message.fromUser.id).collection(message.toUser.id).document().setData(messageData)
        FirebaseCollection.messages.ref.document(message.toUser.id).collection(message.fromUser.id).document().setData(messageData)
    }
    
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
