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
        let pageData = CurrentValueSubject<PageData, Never>(PageData())
    }

    let action = Action()
    let state = State()
    var title: String { "" }
    var nextPageisLoading = false

    private var cancellables = Set<AnyCancellable>()

    init() {
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
                let nextPage = self.state.pageData.value.pageNumber + 1
                if nextPage < self.state.pageData.value.pageSize || nextPage == 0 {
                    self.provider
                        .requestPublisher(.posts(page: nextPage))
                        .map(APIResponse<PageContainer<[Post]>>.self)
                        .map(\.data)
                        .sink(receiveCompletion: { [weak self] completion in
                            guard case let .failure(error) = completion else { return }
                            self?.state.posts.send([])
                            print(error)
                        }, receiveValue: { [weak self] postContainer in

                                guard let self = self else { return }
                            self.state.pageData.send(postContainer.pageable)
                            var newData = self.state.posts.value
                                newData.append(contentsOf: postContainer.content)
                            self.state.posts.send(newData)
                            self.nextPageisLoading = false
                        }).store(in: &self.cancellables)
                }

            })
            .store(in: &cancellables)
        action.fetch.send(())

        action.refresh
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.provider
                    .requestPublisher(.posts())
                    .map(APIResponse<PageContainer<[Post]>>.self)
                    .map(\.data)
                    .sink(receiveCompletion: { [weak self] completion in
                        guard case let .failure(error) = completion else { return }
                        self?.state.posts.send([])
                        print(error)
                    }, receiveValue: { [weak self] postContainer in
                        self?.state.pageData.send(postContainer.pageable)
                        self?.state.posts.send(postContainer.content)
                        self?.nextPageisLoading = false
                    }).store(in: &self.cancellables)
            })
            .store(in: &cancellables)
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
                let nextPage = self.state.pageData.value.pageNumber + 1
                if nextPage < self.state.pageData.value.pageSize || nextPage == 0 {
                    self.provider
                        .requestPublisher(.filteredPosts(type: .developer, page: nextPage))
                        .map(APIResponse<PageContainer<[Post]>>.self)
                        .map(\.data)
                        .sink(receiveCompletion: { [weak self] completion in
                            guard case let .failure(error) = completion else { return }
                            self?.state.posts.send([])
//                            print(String(decoding: error.response!.data, as: UTF8.self))
                            print(error)
                        }, receiveValue: { [weak self] postContainer in

                                guard let self = self else { return }
                            self.state.pageData.send(postContainer.pageable)
                            var newData = self.state.posts.value
                                newData.append(contentsOf: postContainer.content)
                            self.state.posts.send(newData)
                            self.nextPageisLoading = false
                        }).store(in: &self.cancellables)
                }

            })
            .store(in: &cancellables)
        action.fetch.send(())

        action.refresh
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.provider
                    .requestPublisher(.filteredPosts(type: .developer))
                    .map(APIResponse<PageContainer<[Post]>>.self)
                    .map(\.data)
                    .sink(receiveCompletion: { [weak self] completion in
                        guard case let .failure(error) = completion else { return }
                        self?.state.posts.send([])
                        print(error)
                    }, receiveValue: { [weak self] postContainer in
                        self?.state.pageData.send(postContainer.pageable)
                        self?.state.posts.send(postContainer.content)
                        self?.nextPageisLoading = false
                    }).store(in: &self.cancellables)
            })
            .store(in: &cancellables)
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
                let nextPage = self.state.pageData.value.pageNumber + 1
                if nextPage < self.state.pageData.value.pageSize || nextPage == 0 {
                    self.provider
                        .requestPublisher(.filteredPosts(type: .designer, page: nextPage))
                        .map(APIResponse<PageContainer<[Post]>>.self)
                        .map(\.data)
                        .sink(receiveCompletion: { [weak self] completion in
                            guard case let .failure(error) = completion else { return }
                            self?.state.posts.send([])
                            print(error)
                        }, receiveValue: { [weak self] postContainer in

                                guard let self = self else { return }
                            self.state.pageData.send(postContainer.pageable)
                            var newData = self.state.posts.value
                                newData.append(contentsOf: postContainer.content)
                            self.state.posts.send(newData)
                            self.nextPageisLoading = false
                        }).store(in: &self.cancellables)
                }

            })
            .store(in: &cancellables)
        action.fetch.send(())

        action.refresh
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.provider
                    .requestPublisher(.filteredPosts(type: .designer))
                    .map(APIResponse<PageContainer<[Post]>>.self)
                    .map(\.data)
                    .sink(receiveCompletion: { [weak self] completion in
                        guard case let .failure(error) = completion else { return }
                        self?.state.posts.send([])
                        print(error)
                    }, receiveValue: { [weak self] postContainer in
                        self?.state.pageData.send(postContainer.pageable)
                        self?.state.posts.send(postContainer.content)
                        self?.nextPageisLoading = false
                    }).store(in: &self.cancellables)
            })
            .store(in: &cancellables)
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
                let nextPage = self.state.pageData.value.pageNumber + 1
                if nextPage < self.state.pageData.value.pageSize || nextPage == 0 {
                    self.provider
                        .requestPublisher(.filteredPosts(type: .productManager, page: nextPage))
                        .map(APIResponse<PageContainer<[Post]>>.self)
                        .map(\.data)
                        .sink(receiveCompletion: { [weak self] completion in
                            guard case let .failure(error) = completion else { return }
                            self?.state.posts.send([])
                            print(error)
                        }, receiveValue: { [weak self] postContainer in

                                guard let self = self else { return }
                            self.state.pageData.send(postContainer.pageable)
                            var newData = self.state.posts.value
                                newData.append(contentsOf: postContainer.content)
                            self.state.posts.send(newData)
                            self.nextPageisLoading = false
                        }).store(in: &self.cancellables)
                }

            })
            .store(in: &cancellables)
        action.fetch.send(())

        action.refresh
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.provider
                    .requestPublisher(.filteredPosts(type:  .productManager))
                    .map(APIResponse<PageContainer<[Post]>>.self)
                    .map(\.data)
                    .sink(receiveCompletion: { [weak self] completion in
                        guard case let .failure(error) = completion else { return }
                        self?.state.posts.send([])
                        print(error)
                    }, receiveValue: { [weak self] postContainer in
                        self?.state.pageData.send(postContainer.pageable)
                        self?.state.posts.send(postContainer.content)
                        self?.nextPageisLoading = false
                    }).store(in: &self.cancellables)
            })
            .store(in: &cancellables)
    }
}
