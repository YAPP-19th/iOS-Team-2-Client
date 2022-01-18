//
//  ChattingViewModel.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/09.
//

import Combine
import Foundation
import Moya
import Firebase

final class ChattingViewModel: ViewModel {
    
    struct Action {
        let fetch = PassthroughSubject<Void, Never>()
        let refresh = PassthroughSubject<Void, Never>()
    }

    struct State {
        let currentUser = CurrentValueSubject<ChatUser?, Never>(nil)
        let oppositeUser = CurrentValueSubject<ChatUser?, Never>(nil)
        
        let messages = CurrentValueSubject<[ChatMessage], Never>([])
        let recentMessages = CurrentValueSubject<[ChatMessage], Never>([])
    }
    
    private var listener: ListenerRegistration?

    let action = Action()
    let state = State()
    private var cancellables = Set<AnyCancellable>()
    private let provider = MoyaProvider<BudiTarget>()
    
    private let manager = ChatManager.shared
    
    // MARK: - Test/Users
    let currentUser = ChatUser(id: "0",
                         username: "현재 유저",
                         position: "iOS 개발자",
                         profileImageUrl: "https://budi.s3.ap-northeast-2.amazonaws.com/post_image/default/education.jpg")
    let oppositeUser = ChatUser(id: "21",
                         username: "상대 유저",
                         position: "UX 디자이너",
                         profileImageUrl: "https://budi.s3.ap-northeast-2.amazonaws.com/post_image/default/dating.jpg")

    init() {
        state.currentUser.value = currentUser
        state.oppositeUser.value = oppositeUser
        registerTestUsersInfo()
        
        fetchCurrentUserInfo()
        fetchOppositeUserInfo()
        
        fetchRecentMessages()
    }
}

// MARK: - Message
extension ChattingViewModel {
    func fetchRecentMessages() {
        guard let currentUid = currentUser.id else { return }

        let query = FirebaseCollection.recentMessages(uid: currentUid).ref
            .order(by: "timestamp", descending: true)
        
        query.getDocuments { snapshot, error in
            if let error = error { print("error: \(error.localizedDescription)") }
            guard let documents = snapshot?.documents else { return }
            let recentMessages = documents.compactMap { try? $0.data(as: ChatMessage.self) }
            self.state.recentMessages.value = recentMessages
        }
    }
    
    func fetchMessages() {
        guard let currentUid = state.currentUser.value?.id  else { return }
        guard let oppositeUid = state.oppositeUser.value?.id else { return }
        
        let query = FirebaseCollection.messages.ref
            .document(currentUid)
            .collection(oppositeUid)
            .order(by: "timestamp", descending: false)
        
        listener?.remove()
        
        listener = query.addSnapshotListener { [weak self] snapshot, _ in
            guard let self = self else { return }
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }
            let newMessages = changes.compactMap { try? $0.document.data(as: ChatMessage.self) }
            self.state.messages.value.append(contentsOf: newMessages)
        }
        
        query.getDocuments { [weak self] snapshot, _ in
            guard let self = self else { return }
            guard let documents = snapshot?.documents else { return }
            let messages = documents.compactMap { try? $0.data(as: ChatMessage.self) }
            self.state.messages.value = messages
        }
    }
}

// MARK: - User
private extension ChattingViewModel {
    func fetchCurrentUserInfo() {
        guard let currentUid = currentUser.id  else { return }
        
        manager.fetchUserInfo(currentUid) { [weak self] user in
            guard let self = self else { return }
            self.state.currentUser.value = user
        }
    }
}

// MARK: - Test/User, Test/Authentication
private extension ChattingViewModel {
    func sendTestMessages(_ currentUser: ChatUser, _ oppositeUser: ChatUser) {
        self.manager.sendMessage(from: oppositeUser, to: currentUser, "\(Date().convertStringahhmm())에 보낸 테스트 메세지")
    }
    
    func fetchOppositeUserInfo() {
        guard let oppositeUid = state.oppositeUser.value?.id else { return }
        
        manager.fetchUserInfo(oppositeUid) { [weak self] user in
            self?.state.oppositeUser.value = user
        }
    }

    func registerTestUsersInfo() {
        manager.registerUserInfo(currentUser)
        manager.registerUserInfo(oppositeUser)
    }
    
    func createTestUserWithEmail() {
        manager.createUserWithEmail("A@gmail.com", "123456")
        manager.createUserWithEmail("B@gmail.com", "123456")
    }

    func loginWithEmail() {
        manager.loginWithEmail("A@gmail.com", "123456")
    }
}
