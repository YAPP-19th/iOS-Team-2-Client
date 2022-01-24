//
//  NotificationViewModel.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/18.
//

import Combine
import Foundation
import Moya

final class NotificationViewModel: ViewModel {
    
    struct Action {
        let fetch = PassthroughSubject<Void, Never>()
        let refresh = PassthroughSubject<Void, Never>()
    }
    
    struct State {
        let notifications = CurrentValueSubject<[NotificationResponse], Never>([])
    }

    let action = Action()
    let state = State()
    private var cancellables = Set<AnyCancellable>()
    private let provider = MoyaProvider<NotificationTarget>()
    
    init() {
        action.fetch
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                
                // MARK: - 이후 토큰 수정
                let testAccessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJFeHBpcmVkUGVyaW9kIjoiMzYwMCIsInVzZXJJZCI6IjEyMzQ1IiwiaXNzdWVyIjoiU1lKX0lTU1VFIiwibWVtYmVySWQiOjEsImV4cCI6MTY3MjQwNzk5OH0.5Ahg9Gy9Tc9oIGWU_QlLb5qAWoBjwAfoLAsuu2ZyJ-o"

                self.provider
                   .requestPublisher(.notifications(accessToken: testAccessToken, page: 0, size: 100))
                   .map(APIResponse<NotificationContainer<[NotificationResponse]>>.self)
                   .map(\.data)
                   .sink(receiveCompletion: { _ in
                   }, receiveValue: { [weak self] notifications in
                       guard let self = self else { return }
                       self.state.notifications.value = notifications.content
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
