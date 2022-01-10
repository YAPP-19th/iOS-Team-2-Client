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
        let messages = CurrentValueSubject<[ChatMessage], Never>([])
        let recentMessages = CurrentValueSubject<[ChatMessage], Never>([])
    }

    let action = Action()
    let state = State()
    private var cancellables = Set<AnyCancellable>()
    private let provider = MoyaProvider<BudiTarget>()
    
    private let manager = ChatManager.shared
    
    func createTestUserWithEmail() {
        manager.createUserWithEmail("A@gmail.com", "123456")
        manager.createUserWithEmail("B@gmail.com", "123456")
    }
    
    func loginWithEmail() {
        manager.loginWithEmail("A@gmail.com", "123456")
    }
    
    func registerMessage() {
        let userA = manager.userA
        let userB = manager.userB
        guard let uidA = userA.id, let uidB = userB.id else { return }
        
        let message = ChatMessage(timestamp: Timestamp(date: Date()), text: "테스트 메세지", fromUserId: uidA, toUserId: uidB)
        
        manager.registerMessage(message)
    }
    
    func fetchData() {
        let userA = manager.userA
        let userB = manager.userB
        guard let uidA = userA.id, let uidB = userB.id else { return }
        
        ChatManager.shared.fetchMessages(uidA, uidB) { [weak self] messages in
            print("messages: \(messages)")
            self?.state.messages.value = messages
        }

        ChatManager.shared.fetchRecentMessages(uidA) { [weak self] messages in
            print("recentMessages: \(messages)")
            self?.state.recentMessages.value = messages
        }
    }

    init() {
//        createTestUserWithEmail()
//        loginWithEmail()
        registerMessage()
        fetchData()
    }
}
