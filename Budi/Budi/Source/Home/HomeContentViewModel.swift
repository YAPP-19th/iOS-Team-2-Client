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

class HomeContentViewModel: ViewModel {

    struct Action {
        let fetch = PassthroughSubject<Void, Never>()
        let refresh = PassthroughSubject<Void, Never>()
    }

    struct State {
        let posts = CurrentValueSubject<[Post], Never>([])
    }

    let action = Action()
    let state = State()
    var title: String { "" }
    private var cancellables = Set<AnyCancellable>()

    init() {
        action.refresh
            .sink { [weak self] _ in
                self?.action.fetch.send(())
            }.store(in: &cancellables)
    }
}

final class HomeAllContentViewModel: HomeContentViewModel {

    override var title: String { "전체" }
    private let provider = MoyaProvider<BudiTarget>()
    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()
        action.fetch
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                    // 추후 페이징 적용
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
        action.fetch.send(())
    }
}

final class HomeDeveloperContentViewModel: HomeContentViewModel {

    override var title: String { "개발자" }
    private let provider = MoyaProvider<BudiTarget>()
    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()
        action.fetch
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                    // 추후 페이징 적용
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
        action.fetch.send(())
    }
}

final class HomeDesignerContentViewModel: HomeContentViewModel {

    override var title: String { "디자이너" }
    private let provider = MoyaProvider<BudiTarget>()
    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()
        action.fetch
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                    // 추후 페이징 적용
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
        action.fetch.send(())
    }
}

final class HomeProductManagerContentViewModel: HomeContentViewModel {

    override var title: String { "기획자" }
    private let provider = MoyaProvider<BudiTarget>()
    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()
        action.fetch
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                    // 추후 페이징 적용
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
        action.fetch.send(())
    }
}
