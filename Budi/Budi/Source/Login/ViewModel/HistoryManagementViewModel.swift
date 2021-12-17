//
//  HistoryManagementViewModel.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/26.
//

import UIKit
import Combine
import CombineCocoa

final class HistoryManagementViewModel: ViewModel {
    typealias ResultCharacters = Result<[String], Error>
    var cancellables = Set<AnyCancellable>()
    var workHistory: [WorkHistory] = []
    var projectHistory: [ProjectHistory] = []
    var portFolioLink: [String] = []
    var historyArray = [[UUID()], [UUID()], [UUID()]]
    let headerData = ["경력", "프로젝트 이력", "포트폴리오"]
    struct Action {
        var tag = PassthroughSubject<Int, Never>()
        var title = PassthroughSubject<[String], Never>()
    }

    struct State {
        var titleAppend = CurrentValueSubject<Void, Never>(())
        var selectIndex = CurrentValueSubject<Int, Never>(1)
    }

    let action = Action()
    let state = State()

    init() {
        configure()
    }

    private func configure() {
        action.tag
            .sink { tag in
                self.state.selectIndex.send(tag)
            }
            .store(in: &cancellables)
    }

    func getHeaderData() -> [String] {
        return headerData
    }

    func addCompany(_ history: WorkHistory) {
        //historyArray[historyArray.endIndex] = history
        workHistory.append(history)
    }

    func addProject(_ history: ProjectHistory) {
        projectHistory.append(history)
    }

    func addPortFolio(_ link: String) {
        portFolioLink.append(link)
    }
}
