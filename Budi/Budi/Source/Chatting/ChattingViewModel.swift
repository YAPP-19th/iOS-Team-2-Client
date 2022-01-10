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
        let currentUser = ChatManager.shared.testCurrentUser
        let otherUser = ChatManager.shared.testOtherUser
        
        let newMessage = ChatMessage(id: NSUUID().uuidString, time: Date().convertStringahhmm(), text: "새로운 메세지", fromUser: currentUser, toUser: otherUser)
        
        ChatManager.shared.registerMessage(newMessage)
        ChatManager.shared.fetchMessages(currentUser.id)
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
