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
        let sender = CurrentValueSubject<ChatUser?, Never>(nil)
        let recipient = CurrentValueSubject<ChatUser?, Never>(nil)
        
        let messages = CurrentValueSubject<[ChatMessage], Never>([])
        let recentMessages = CurrentValueSubject<[ChatMessage], Never>([])
    }

    let action = Action()
    let state = State()
    private var cancellables = Set<AnyCancellable>()
    private let provider = MoyaProvider<BudiTarget>()
    
    private let manager = ChatManager.shared

    init() {
//        createTestUserWithEmail()
//        loginWithEmail()
//        registerUserInfo()
//        registerMessage()
        fetchUsers()
        fetchAllMessages()
    }
}

private extension ChattingViewModel {
    func fetchUsers() {
        let userA = manager.userA
        let userB = manager.userB
        guard let uidA = userA.id, let uidB = userB.id else { return }

        manager.fetchUser(uidA) { [weak self] user in
            self?.state.sender.value = user
        }
        manager.fetchUser(uidB) { [weak self] user in
            self?.state.recipient.value = user
        }
    }
    
    func fetchAllMessages() {
        let userA = manager.userA
        let userB = manager.userB
        guard let uidA = userA.id, let uidB = userB.id else { return }
        
        manager.fetchMessages(uidA, uidB) { [weak self] messages in
            self?.state.messages.value = messages
        }

        manager.fetchRecentMessages(uidA) { [weak self] messages in
            self?.state.recentMessages.value = messages
        }
    }
    
    func registerUserInfo() {
        let userA = manager.userA
        let userB = manager.userB
        manager.registerUserInfo(userA)
        manager.registerUserInfo(userB)
    }
    
    func registerMessage() {
        let userA = manager.userA
        let userB = manager.userB
        guard let uidA = userA.id, let uidB = userB.id else { return }
        
        let message = ChatMessage(text: "테스트 메세지입니다", fromUserId: uidA, toUserId: uidB)
  
        manager.registerMessage(message)
    }
}

// MARK: - Authentication
private extension ChattingViewModel {
    func createTestUserWithEmail() {
        manager.createUserWithEmail("A@gmail.com", "123456")
        manager.createUserWithEmail("B@gmail.com", "123456")
    }
    
    func loginWithEmail() {
        manager.loginWithEmail("A@gmail.com", "123456")
    }
}
