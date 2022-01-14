//
//  TeamSearchFilterViewModel.swift
//  Budi
//
//  Created by 최동규 on 2022/01/08.
//

import Foundation
import Combine
import Moya

final class TeamSearchFilterViewModel: ViewModel {
    struct Action {
        let fetch = PassthroughSubject<Void, Never>()
        let refresh = PassthroughSubject<Void, Never>()
    }

    struct State {
        let sections = CurrentValueSubject<[TeamSearchPositionSection], Never>([])

        let pageData = CurrentValueSubject<PageData, Never>(PageData())
    }

    private var cancellables = Set<AnyCancellable>()
    private let provider = MoyaProvider<MemberTarget>()
    var nextPageisLoading = false
    let position: Position
    let action = Action()
    let state = State()
    
    init(position: Position) {

        self.position = position
        action.fetch
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                let nextPage = self.state.pageData.value.pageNumber + 1
                if nextPage < self.state.pageData.value.pageSize || nextPage == 0 {
                    self.provider
                        .requestPublisher(.memberList(postion: position, page: nextPage, size: 20))

                        .map(APIResponse<PageContainer<[SearchTeamMember]>>.self.self)
                        .map(\.data)
                        .sink(receiveCompletion: { [weak self] completion in
                            guard case let .failure(error) = completion else { return }
                            self?.state.sections.send([])
                            print(error)
                        }, receiveValue: { [weak self] memberContainer in
                            guard let self = self else { return }
                            self.state.pageData.send(memberContainer.pageable)
                            let newData = self.state.sections.value
                            var newItems = newData.first?.items ?? []

                            newItems.append(contentsOf: memberContainer.content)
                            self.state.sections.send([.init(position: position, items: newItems)])
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
                    .requestPublisher(.memberList(postion: position, page: 0, size: 5))
                    .map(APIResponse<PageContainer<[SearchTeamMember]>>.self.self)
                    .map(\.data)
                    .sink(receiveCompletion: { [weak self] completion in
                        guard case let .failure(error) = completion else { return }
                        self?.state.sections.send([])
                        print(error)
                    }, receiveValue: { [weak self] memberContainer in
                        self?.state.pageData.send(memberContainer.pageable)
                        self?.state.sections.send([.init(position: position, items: memberContainer.content)])
                        self?.nextPageisLoading = false
                    }).store(in: &self.cancellables)
            })
            .store(in: &cancellables)
    }

}
