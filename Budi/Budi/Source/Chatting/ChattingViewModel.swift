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
        registerUserInfo()
        fetchCurrentUserInfo()
        fetchRecentMessages()
    }
}

private extension ChattingViewModel {
    func fetchRecentMessages() {
        let currentUser = manager.currentUser
        guard let currentUid = currentUser.id else { return }

        manager.fetchRecentMessages(currentUid) { [weak self] recentMessages in
            self?.state.recentMessages.value = recentMessages
        }
    }
}

// MARK: - User
private extension ChattingViewModel {
    func fetchCurrentUserInfo() {
        let currentUser = manager.currentUser
        guard let currentUid = currentUser.id else { return }

        manager.fetchUserInfo(currentUid) { [weak self] user in
            self?.state.currentUser.value = user
        }
    }
    
    func registerUserInfo() {
        let currentUser = manager.currentUser
        let oppositeUser = manager.oppositeUser
        
        manager.registerUserInfo(currentUser)
        manager.registerUserInfo(oppositeUser)
    }
}

// MARK: - Test/Authentication
private extension ChattingViewModel {
    func createTestUserWithEmail() {
        manager.createUserWithEmail("A@gmail.com", "123456")
        manager.createUserWithEmail("B@gmail.com", "123456")
    }

    func loginWithEmail() {
        manager.loginWithEmail("A@gmail.com", "123456")
    }
}
