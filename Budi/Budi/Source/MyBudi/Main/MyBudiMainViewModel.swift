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

        loginStatusCheck()
    }

    func loginStatusCheck() {
        action.LoginStatusCheck
            .receive(on: DispatchQueue.global())
            .sink { [weak self] _ in
                guard let self = self else { return }
                let loginModel = LoginCheckModel(accessToken: UserDefaults.standard.string(forKey: "accessToken") ?? "")
                print("저장된 숫자:", UserDefaults.standard.integer(forKey: "memberId"))
                print("저장된 엑세스 토큰:", UserDefaults.standard.string(forKey: "accessToken"))
                self.provider
                    .requestPublisher(.signUpStatusCheck(memberId: UserDefaults.standard.integer(forKey: "memberId"), header: loginModel))
                    .map(APIResponse<LoginUserDetail>.self)
                    .map(\.data)
                    .sink(receiveCompletion: { [weak self] completion in
                        guard let self = self else { return }
                        switch completion {
                        case .failure(let error):
                            print("일로")
                            print(error.localizedDescription)
                        case .finished:
                            break
                        }
                        self.state.loginStatusData.send(nil)
                    }, receiveValue: { post in
                        print(post.id)
                        print(post.nickName)
                    })
                    .store(in: &self.cancellables)

            }
            .store(in: &cancellables)
    }
}
