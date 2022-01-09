//
//  ChattingViewModel.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/09.
//

import Combine
import Foundation
import Moya

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
    
    
    init() {
        action.fetch
            .sink(receiveValue: { [weak self] _ in
//                guard let self = self else { return }
//
//                self.provider
//                    .requestPublisher(.post(accessToken: .testAccessToken, id: postId))
//                    .map(APIResponse<Post>.self)
//                    .map(\.data)
//                    .sink(receiveCompletion: { _ in
//                    }, receiveValue: { [weak self] post in
//                        self?.state.post.send(post)
//                    })
//                    .store(in: &self.cancellables)
                
            }).store(in: &cancellables)

        action.refresh
            .sink { [weak self] _ in
                self?.action.fetch.send(())
            }.store(in: &cancellables)

        action.fetch.send(())
    }
}
