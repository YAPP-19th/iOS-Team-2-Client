//
//  MyBudiMainViewModel.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/22.
//

import Combine
import Foundation
import Moya

class MyBudiMainViewModel: ViewModel {
    
    struct Action {
        let fetch = PassthroughSubject<Void, Never>()
        let refresh = PassthroughSubject<Void, Never>()
        let LoginStatusCheck = PassthroughSubject<Void, Never>()
    }

    struct State {
        let loginStatusData = CurrentValueSubject<LoginUserDetail?, Never>(nil)
    }
    
    let action = Action()
    let state = State()
    private var cancellables = Set<AnyCancellable>()
    private let provider = MoyaProvider<BudiTarget>()
    
    init() {
        action.fetch
            .sink(receiveValue: { _ in
            }).store(in: &cancellables)

        action.refresh
            .sink { [weak self] _ in
                self?.action.fetch.send(())
            }.store(in: &cancellables)

        action.fetch.send(())

        action.LoginStatusCheck
            .receive(on: DispatchQueue.global())
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.provider
                    .requestPublisher(.signUpStatusCheck(memberId: UserDefaults.standard.integer(forKey: "memberId")))
                    .map(APIResponse<LoginUserDetail>.self)
                    .map(\.data)
                    .sink(receiveCompletion: { [weak self] completion in
                        switch completion {
                        case .failure(let error):
                            print(error.localizedDescription)
                        case .finished:
                            break
                        }
                    }, receiveValue: { post in
                        if post.nickName != "" {
                            print(post)
                            let user = LoginUserDetail(id: post.id,
                                                       imageUrl: post.imageUrl,
                                                       nickName: post.nickName,
                                                       description: post.description,
                                                       level: post.level,
                                                       positions: post.positions,
                                                       likeCount: post.likeCount,
                                                       projectList: post.projectList,
                                                       portfolioList: post.portfolioList,
                                                       isLikedFromCurrentMember: post.isLikedFromCurrentMember)
                            self.state.loginStatusData.send(user)
                        }
                    })
                    .store(in: &self.cancellables)

            }
            .store(in: &cancellables)
    }
}
