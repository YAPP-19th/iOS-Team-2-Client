//
//  TeamSearchViewModel.swift
//  Budi
//
//  Created by 최동규 on 2021/12/30.
//

import Combine
import Moya

struct TeamSearchViewModelSection {
    let postion: Position
    let items: [SearchTeamMember]
}

final class TeamSearchViewModel: ViewModel {

    struct Action {
        let fetch = PassthroughSubject<Void, Never>()
        let refresh = PassthroughSubject<Void, Never>()
    }

    struct State {
        let sections = CurrentValueSubject<[TeamSearchViewModelSection], Never>([])
    }

    let action = Action()
    let state = State()

    private var cancellables = Set<AnyCancellable>()
    private let provider = MoyaProvider<MemberTarget>()

    init() {
        action.fetch
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
//                self.state.sections.send([.init(postion: .developer, items: [.init(id: 123, imgURL: "", nickName: "", address: "", introduce: "", position: ["asdf"], likeCount: 0)])])
                Publishers.CombineLatest3(self.provider
                                            .requestPublisher(.memberList(postion: .developer))
                                            .map(APIResponse<[SearchTeamMember]>.self)
                                            .map(\.data), self.provider
                                            .requestPublisher(.memberList(postion: .designer))
                                            .map(APIResponse<[SearchTeamMember]>.self)
                                            .map(\.data), self.provider
                                            .requestPublisher(.memberList(postion: .productManager))
                                            .map(APIResponse<[SearchTeamMember]>.self)
                                            .map(\.data))
                    .sink(receiveCompletion: { [weak self] completion in
                        guard case let .failure(error) = completion else { return }
                        self?.state.sections.send([])
                        print(error)
                    }, receiveValue: { [weak self] (developerMembers, designerMembers, productMembers) in
                        guard let self = self else { return }
                        self.state.sections.send([.init(postion: .developer, items: developerMembers), .init(postion: .designer, items: designerMembers), .init(postion: .productManager, items: productMembers)])
                    }).store(in: &self.cancellables)

            })
            .store(in: &cancellables)

        action.fetch.send(())

        action.refresh
            .sink(receiveValue: { [weak self] _ in
                self?.action.fetch.send(())
            })
            .store(in: &cancellables)
    }

}
