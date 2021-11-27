//
//  SignupNormalViewModel.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/19.
//

import UIKit
import Combine
import NaverThirdPartyLogin

final class SignupNormalViewModel: ViewModel {
    struct Action {
        let fetch = PassthroughSubject<Void, Never>()
        let refresh = PassthroughSubject<Void, Never>()
    }

    struct State {
        let naverData = CurrentValueSubject<NaverData?, Never>(nil)
        let loginUserData = CurrentValueSubject<LoginResponse?, Never>(nil)
    }

    let action = Action()
    let state = State()

    var cancellables = Set<AnyCancellable>()
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()

    init() {
        getNaverInfo()
    }

    func getNaverInfo() {
        guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }

        if !isValidAccessToken {
            return
        }

        guard let tokenType = loginInstance?.tokenType else { return }
        guard let accessToken = loginInstance?.accessToken else { return }
        let urlStr = "https://openapi.naver.com/v1/nid/me"

        guard let url = URL(string: urlStr) else { return }
        let auth = "\(tokenType) \(accessToken)"
        var request = URLRequest(url: url)
        request.setValue(auth, forHTTPHeaderField: "Authorization")

        action.fetch
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                URLSession.shared.dataTaskPublisher(for: request)
                    .subscribe(on: DispatchQueue.global(qos: .background))
                    .receive(on: DispatchQueue.main)
                    .tryMap { data, response -> Data in
                        guard
                            let response = response as? HTTPURLResponse,
                            response.statusCode < 400 else { throw URLError(.badServerResponse) }
                        return data
                    }
                    .decode(type: Response.self, decoder: JSONDecoder())
                    .sink(receiveCompletion: { [weak self] completion in
                        guard case let .failure(error) = completion else { return }
                        print(error)
                        self?.state.naverData.send(nil)
                    }, receiveValue: { [weak self] posts in
                        print()
                        self?.state.naverData.send(posts.response)
                    })
                    .store(in: &self.cancellables)

            })
            .store(in: &cancellables)

        action.refresh
            .sink { [weak self] _ in
                self?.action.fetch.send(())
            }.store(in: &cancellables)

        action.fetch.send(())
    }

    func pushServer() {
        guard let id = state.naverData.value?.id else { return }
        let loginData = Login(loginId: id, name: state.naverData.value?.name, email: state.naverData.value?.email)
        guard let uploadData = try? JSONEncoder().encode(loginData) else { return }

        guard let url = URL(string: .baseURLString+"/auth/login") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        action.fetch
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                URLSession.shared.uploadTask(with: request, from: uploadData) { (data, response, error) in
                    if let error = error {
                        NSLog("Error:\(error.localizedDescription)")
                        return
                    }
                    print("응답 완료")
                    guard let data = data else { return }
                    do {
                        // 서버에 로그인 시도 하고 받은 데이터
                        let decodeData = try JSONDecoder().decode(APIResponse<LoginResponse>.self, from: data)
                        print("로그인 유저 아이디 :", decodeData.data.userId)
                        print("로그인 고유 토큰 :", decodeData.data.accessToken)
                    } catch {
                        print("Error")
                    }
                }
                .resume()
            })
            .store(in: &cancellables)

        action.refresh
            .sink { [weak self] _ in
                self?.action.fetch.send(())
            }.store(in: &cancellables)

        action.fetch.send(())
    }
}
