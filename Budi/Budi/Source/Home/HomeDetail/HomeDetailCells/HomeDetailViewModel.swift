//
//  HomeDetailViewModel.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/25.
//
import Combine
import Foundation
import Moya

final class HomeDetailViewModel: ViewModel {

    struct Action {
        let fetch = PassthroughSubject<Void, Never>()
        let refresh = PassthroughSubject<Void, Never>()
    }

    struct State {
        let postId = CurrentValueSubject<Int, Never>(0)
        let post = CurrentValueSubject<Post?, Never>(nil)
        let teamMembers = CurrentValueSubject<[TeamMember], Never>([])
        let recruitingStatuses = CurrentValueSubject<[RecruitingStatus], Never>([])
    }

    let action = Action()
    let state = State()
    private var cancellables = Set<AnyCancellable>()
    private let provider = MoyaProvider<BudiTarget>()
    
    func requestApplies(_ accessToken: String, _ param: AppliesRequest, _ completion: @escaping (Result<Moya.Response, Error>) -> Void) {
        
        provider.request(.applies(accessToken: accessToken, param: param)) { response in
            switch response {
            case .success(let response): completion(.success(response))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func requestLikePost(_ accessToken: String, _ completion: @escaping (Result<Moya.Response, Error>) -> Void) {
        provider.request(.likePosts(accessToken: accessToken, id: self.state.postId.value)) { response in
            switch response {
            case .success(let response):
                self.state.post.value?.isLiked.toggle()
                if let isLiked = self.state.post.value?.isLiked {
                    self.state.post.value?.likeCount += (isLiked ? 1 : (-1))
                }
                completion(.success(response))
            case .failure(let error): completion(.failure(error))
            }
        }
    }

    init(_ postId: Int) {
        self.state.postId.value = postId
                
        action.fetch
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }

                self.provider
                    .requestPublisher(.post(accessToken: TEST_ACCESS_TOKEN, id: postId))
                    .map(APIResponse<Post>.self)
                    .map(\.data)
                    .sink(receiveCompletion: { _ in
                    }, receiveValue: { [weak self] post in
                        print("post is \(post)")
                        self?.state.post.send(post)
                    })
                    .store(in: &self.cancellables)
                
                self.provider
                    .requestPublisher(.teamMembers(id: postId))
                    .map(APIResponse<TeamMemberContainer>.self)
                    .map(\.data)
                    .sink(receiveCompletion: { _ in
                    }, receiveValue: { [weak self] container in
                        print("teamMembers is \(container.teamMembers)")
                        self?.state.teamMembers.send(container.teamMembers)
                    })
                    .store(in: &self.cancellables)
                
                self.provider
                    .requestPublisher(.recruitingStatuses(id: postId))
                    .map(APIResponse<RecruitingStatusContainer>.self)
                    .map(\.data)
                    .sink(receiveCompletion: { _ in
                    }, receiveValue: { [weak self] container in
                        print("recruitingStatuses is \(container.recruitingStatuses)")
                        self?.state.recruitingStatuses.send(container.recruitingStatuses)
                    })
                    .store(in: &self.cancellables)
                
            }).store(in: &cancellables)

        action.refresh
            .sink { [weak self] _ in
                self?.action.fetch.send(())
            }.store(in: &cancellables)

        action.fetch.send(())
    }
}
