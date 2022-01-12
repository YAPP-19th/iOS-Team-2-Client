//
//  MyBudiEditViewModel.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/22.
//

import Combine
import Foundation
import Moya

class MyBudiEditViewModel: ViewModel {
    
    struct Action {
        let fetch = PassthroughSubject<Void, Never>()
        let refresh = PassthroughSubject<Void, Never>()
        let switchView = PassthroughSubject<ModalControl, Never>()
        let deleteProjectData = PassthroughSubject<Int, Never>()
        let deletePortfolioData = PassthroughSubject<Int, Never>()
    }

    struct State {
        let developerPositions = CurrentValueSubject<[String], Never>([])
        let designerPositions = CurrentValueSubject<[String], Never>([])
        let productManagerPositions = CurrentValueSubject<[String], Never>([])
        let loginUserData = CurrentValueSubject<LoginUserDetail?, Never>(nil)
        let dataChanged = CurrentValueSubject<Int, Never>(1)
    }

    let action = Action()
    let state = State()
    private var cancellables = Set<AnyCancellable>()
    private let provider = MoyaProvider<BudiTarget>()
    
    init() {
        action.fetch
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                
                self.provider
                    .requestPublisher(.detailPositions(position: .developer))
                    .map(APIResponse<[String]>.self)
                    .map(\.data)
                    .sink(receiveCompletion: { _ in
                    }, receiveValue: { [weak self] positions in
                        self?.state.developerPositions.send(positions)
                    })
                    .store(in: &self.cancellables)

                self.provider
                    .requestPublisher(.detailPositions(position: .designer))
                    .map(APIResponse<[String]>.self)
                    .map(\.data)
                    .sink(receiveCompletion: { _ in
                    }, receiveValue: { [weak self] positions in
                        self?.state.designerPositions.send(positions)
                    })
                    .store(in: &self.cancellables)

                self.provider
                    .requestPublisher(.detailPositions(position: .productManager))
                    .map(APIResponse<[String]>.self)
                    .map(\.data)
                    .sink(receiveCompletion: { _ in
                    }, receiveValue: { [weak self] positions in
                        self?.state.productManagerPositions.send(positions)
                    })
                    .store(in: &self.cancellables)

            }).store(in: &cancellables)

        action.deleteProjectData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] idx in
                guard let self = self else { return }
                var changeData = self.state.loginUserData.value
                changeData?.projectList.remove(at: idx)
                print("바뀐 데이터", changeData)
                self.state.loginUserData.send(changeData)
                self.state.dataChanged.send(1)
                print("2")
            }
            .store(in: &cancellables)

        action.deletePortfolioData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] idx in
                guard let self = self else { return }
                var changeData = self.state.loginUserData.value
                changeData?.portfolioList.remove(at: idx)
                print("바뀐 데이터", changeData)
                self.state.loginUserData.send(changeData)
                self.state.dataChanged.send(2)
            }
            .store(in: &cancellables)

        action.refresh
            .sink { [weak self] _ in
                self?.action.fetch.send(())
            }.store(in: &cancellables)

        action.fetch.send(())
    }
}
