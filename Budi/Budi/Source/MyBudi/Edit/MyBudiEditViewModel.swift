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
    }

    struct State {
        let loginUserData = CurrentValueSubject<LoginUserDetail?, Never>(nil)
        let mySectionData = CurrentValueSubject<[HistorySectionModel], Never>(
            [
                HistorySectionModel.init(
                    type: .project,
                    sectionTitle: ModalControl.project.stringValue ,
                    items: [
                        Item(itemInfo: ItemInfo(isInclude: false, buttonTitle: "프로젝트 이력을 추가해보세요"),
                             description: "", endDate: "", name: "", nowWork: false, startDate: "", portfolioLink: "")]),

                HistorySectionModel.init(
                    type: .portfolio,
                    sectionTitle: ModalControl.portfolio.stringValue ,
                    items: [
                        Item(itemInfo: ItemInfo(isInclude: false, buttonTitle: "포트폴리오를 추가해보세요"),
                             description: "", endDate: "", name: "", nowWork: false, startDate: "", portfolioLink: "")])
            ])
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
    }
}
