//
//  TeamSearchProfileViewModel.swift
//  Budi
//
//  Created by 최동규 on 2022/01/12.
//

import Combine
import Moya

final class TeamSearchProfileViewModel: ViewModel {
    struct Action {
        let fetch = PassthroughSubject<Void, Never>()
        let refresh = PassthroughSubject<Void, Never>()
    }

    struct State {
        let member = CurrentValueSubject<BudiMember?, Never>(nil)
        let reviews = CurrentValueSubject<[Review], Never>([])
        let evaluations = CurrentValueSubject<Evaluation?, Never>(nil)
    }

    private var cancellables = Set<AnyCancellable>()
    private let provider = MoyaProvider<MemberTarget>()

    let memberID: String
    let action = Action()
    let state = State()

    init(memberID: String) {
        self.memberID = memberID
        action.fetch
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                Publishers.CombineLatest3(
                    self.provider
                        .requestPublisher(.memberDetails(accessToken: UserDefaults.standard.string(forKey: "accessToken") ?? "", id: memberID))
                        .map(APIResponse<BudiMember>.self)
                        .map(\.data)
                    ,
                    self.provider
                        .requestPublisher(.reviews(memberID: memberID))
                        .map(APIResponse<PageContainer<[Review]>>.self)
                        .map(\.data.content)
                    ,
                    self.provider
                        .requestPublisher(.evalutation(memberID: memberID))
                        .map(APIResponse<Evaluation>.self)
                        .map(\.data)
                )
                    .sink(receiveCompletion: { [weak self] completion in
                        guard case let .failure(error) = completion else { return }
                        self?.state.member.send(nil)
                        self?.state.evaluations.send(nil)
                        self?.state.reviews.send([])
                        print(error)
                    }, receiveValue: { [weak self] (member, reviews, evaluation) in
                        guard let self = self else { return }
                        self.state.member.send(member)
                        self.state.reviews.send(reviews)
                        self.state.evaluations.send(evaluation)
                    }).store(in: &self.cancellables)
            })
            .store(in: &cancellables)
//
        action.fetch.send(())
//
//        action.refresh
//            .sink(receiveValue: { [weak self] _ in
//                self?.action.fetch.send(())
//            })
//            .store(in: &cancellables)
    }
}
