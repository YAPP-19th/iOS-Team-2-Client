//
//  HomeViewModel.swift
//  Budi
//
//  Created by 최동규 on 2021/11/21.
//

import Combine
import Foundation
import Moya

protocol ViewModel {

    associatedtype Action
    associatedtype State

    var action: Action { get }
    var state: State { get }
}

final class HomeViewModel: ViewModel {

    struct Action {
        let fetch = PassthroughSubject<Void, Never>()
        let refresh = PassthroughSubject<Void, Never>()
    }

    struct State {
        let posts = CurrentValueSubject<[Post], Never>([])
    }

    let action = Action()
    let state = State()
    private var cancellables = Set<AnyCancellable>()
    private let provider = MoyaProvider<BudiTarget>()

    init() {
        action.fetch
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                    // 추후 목록에 페이징이 적용되면 이부분이 조금 바뀔듯
                self.provider
                    .requestPublisher(.posts)
                    .map(APIResponse<PostContainer>.self)
                    .map(\.data.content)
                    .sink(receiveCompletion: { [weak self] completion in
                        // 에러 핸들링
                        guard case let .failure(error) = completion else { return }
                        self?.state.posts.send([])
                        print(error)
                    }, receiveValue: { [weak self] posts in
                        self?.state.posts.send(posts)
                    }).store(in: &self.cancellables)
            })
            .store(in: &cancellables)

        action.refresh
            .sink { [weak self] _ in
                self?.action.fetch.send(())
            }.store(in: &cancellables)

        action.fetch.send(())
    }
}
