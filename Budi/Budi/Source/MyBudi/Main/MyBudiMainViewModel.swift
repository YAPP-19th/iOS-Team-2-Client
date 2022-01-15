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
        let loadProjectStatus = PassthroughSubject<Void, Never>()
    }

    struct State {
        let loginStatusData = CurrentValueSubject<BudiMember?, Never>(nil)
        let likedData = CurrentValueSubject<MyLikePost?, Never>(nil)
        let projectData = CurrentValueSubject<MyBudiProject?, Never>(nil)
        let pageData = CurrentValueSubject<PageData, Never>(PageData())
    }

    let action = Action()
    let state = State()
    var title: String { "" }
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
                    .map(APIResponse<BudiMember>.self)
                    .map(\.data)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            print(error.localizedDescription)
                        case .finished:
                            break
                        }
                    }, receiveValue: { post in
                        if post.nickName != "" {
                            var data = post
                            if data.portfolioList.count == 1 && data.portfolioList[0] == "" {
                                data.portfolioList = ["포트폴리오 링크로 수정해보세요!"]
                            }
                            self.state.loginStatusData.send(data)
                        } else {
                            self.state.loginStatusData.send(nil)
                        }
                    })
                    .store(in: &self.cancellables)

            }
            .store(in: &cancellables)

        action.loadProjectStatus
            .receive(on: DispatchQueue.global())
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.provider
                    .requestPublisher(.myLikePosts(accessToken: UserDefaults.standard.string(forKey: "accessToken") ?? ""))
                    .map(APIResponse<MyLikePost>.self)
                    .map(\.data)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            print(error.localizedDescription)
                        case .finished:
                            break
                        }
                    }, receiveValue: { post in
                        self.state.likedData.send(post)
                    })
                    .store(in: &self.cancellables)

                self.provider
                    .requestPublisher(.getMyBudiProject(accessToken: UserDefaults.standard.string(forKey: "accessToken") ?? ""))
                    .map(APIResponse<MyBudiProject>.self)
                    .map(\.data)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            print(error.localizedDescription)
                        case .finished:
                            break
                        }
                    }, receiveValue: { post in
                        self.state.projectData.send(post)
                    })
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
    }
}

final class AppliedProjectViewModel: MyBudiMainViewModel {

    override var title: String { "지원한" }
    private let provider = MoyaProvider<BudiTarget>()
    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()

    }
}

final class ParticipatedProjectViewModel: MyBudiMainViewModel {

    override var title: String { "참여중" }
    private let provider = MoyaProvider<BudiTarget>()
    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()

    }
}

final class DoneProjectViewModel: MyBudiMainViewModel {

    override var title: String { "완료" }
    private let provider = MoyaProvider<BudiTarget>()
    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()

    }
}
