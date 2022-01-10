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
        let chatMessages = CurrentValueSubject<[ChatMessage], Never>([])
    }

    let action = Action()
    let state = State()
    private var cancellables = Set<AnyCancellable>()
    private let provider = MoyaProvider<BudiTarget>()
    
    func fetchData() {
//        let currentUser = ChatManager.shared.testCurrentUser
//        let otherUser = ChatManager.shared.testOtherUser
//
        // MARK: - TestMessage
//        let testMessage = ChatMessage(id: NSUUID().uuidString, time: Date().convertStringahhmm(), text: "테스트 메세지", fromUserId: currentUser.id, toUserId: otherUser.id)
//
//        ChatManager.shared.registerMessage(testMessage)
//
//        let messages = ChatManager.shared.fetchMessages(currentUser.id, otherUser.id)
//        print("messages data: \(messages)")
//
//        let recentMessages = ChatManager.shared.fetchRecentMessages(currentUser.id)
//        print("recent-messages data: \(recentMessages)")
    }
    
    init() {
        fetchData()
        
        action.fetch
            .sink(receiveValue: { _ in
            }).store(in: &cancellables)

        action.refresh
            .sink { [weak self] _ in
                self?.action.fetch.send(())
            }.store(in: &cancellables)

        action.fetch.send(())
    }
}
