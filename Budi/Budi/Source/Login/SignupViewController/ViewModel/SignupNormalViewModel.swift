//
//  SignupNormalViewModel.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/19.
//

import UIKit
import Combine
import NaverThirdPartyLogin

class SignupNormalViewModel: ObservableObject {
    @Published var naverName: String = ""
    @Published var naverEmail: String = ""
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

        if let url = URL(string: urlStr) {
            let auth = "\(tokenType) \(accessToken)"

            var request = URLRequest(url: url)
            request.setValue(auth, forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTaskPublisher(for: request)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .tryMap { data, response -> Data in
                    guard
                        let response = response as? HTTPURLResponse,
                        response.statusCode < 400 else { throw URLError(.badServerResponse) }
                    return data
                }
                .decode(type: NaverData.self, decoder: JSONDecoder())
                .sink { completion in
                    print("Completion: \(completion)")
                } receiveValue: { data in
                    // 강한참조 문제 해결하기 위해서 약한 참조 실행
                    print(data.response.name, data.response.email)
                    self.naverName = data.response.name
                    self.naverEmail = data.response.email
                }
                .store(in: &cancellables)
        }
    }
}
