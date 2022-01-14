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
        let postUserData = PassthroughSubject<Void, Never>()
    }

    struct State {
        let developerPositions = CurrentValueSubject<[String], Never>([])
        let designerPositions = CurrentValueSubject<[String], Never>([])
        let productManagerPositions = CurrentValueSubject<[String], Never>([])
        let loginUserData = CurrentValueSubject<BudiMember?, Never>(nil)
        let dataChanged = CurrentValueSubject<Int, Never>(1)
        let userInfoUploadStatus = CurrentValueSubject<String?, Never>(nil)
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
                self.state.loginUserData.send(changeData)
                self.state.dataChanged.send(1)
            }
            .store(in: &cancellables)

        action.deletePortfolioData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] idx in
                guard let self = self else { return }
                var changeData = self.state.loginUserData.value
                changeData?.portfolioList.remove(at: idx)
                self.state.loginUserData.send(changeData)
                self.state.dataChanged.send(2)
            }
            .store(in: &cancellables)

        action.refresh
            .sink { [weak self] _ in
                self?.action.fetch.send(())
            }.store(in: &cancellables)

        action.fetch.send(())

        action.postUserData
            .receive(on: DispatchQueue.global())
            .sink { [weak self] _ in
                guard let self = self else { return }
                guard let accsessToken = UserDefaults.standard.string(forKey: "accessToken") else { return }
                let projectList = self.state.loginUserData.value?.projectList ?? []
                let portfolioList = self.state.loginUserData.value?.portfolioList ?? []
                var uploadCareerList: [CareerList] = []
                var uploadProjectList: [TList] = []
                var uploadPortfolioList: [String] = []
                // 프로젝트 리스트 변환
                for project in projectList {
                    let tmp = TList(description: project.description,
                                    endDate: project.endDate,
                                    name: project.name,
                                    startDate: project.startDate)
                    if !tmp.name.isEmpty {
                        uploadProjectList.append(tmp)
                    }
                }

                // 포트폴리오 리스트 변환
                for portfolio in portfolioList {
                    uploadPortfolioList.append(portfolio)
                }

                let param = CreateInfo(
                    basePosition: self.state.loginUserData.value?.basePosition ?? 0,
                    imgUrl: self.state.loginUserData.value?.imgUrl ?? "",
                    careerList: uploadCareerList,
                    description: self.state.loginUserData.value?.description ?? "",
                    memberAddress: self.state.loginUserData.value?.address ?? "",
                    nickName: self.state.loginUserData.value?.nickName ?? "",
                    portfolioLink: uploadPortfolioList,
                    positionList: self.state.loginUserData.value?.positions ?? [],
                    projectList: uploadProjectList
                )
                self.provider.requestPublisher(.createInfo(acessToken: accsessToken, param: param))
                    .map(UserInfoUploadSuccess.self)
                    .sink(receiveCompletion: { [weak self] completion in
                        guard let self = self else { return }
                        guard case let .failure(error) = completion else { return }
                        self.state.userInfoUploadStatus.send(nil)
                        print(error.localizedDescription)

                    }, receiveValue: { post in
                        self.state.userInfoUploadStatus.send(post.message)
                        NotificationCenter.default.post(name: Notification.Name("LoginSuccessed"), object: nil)

                    })
                    .store(in: &self.cancellables)

            }
            .store(in: &cancellables)
    }

    func convertImageToURL(_ jpegData: Data, _ completion: @escaping (Result<Moya.Response, Error>) -> Void) {
        provider.request(.convertImageToURL(jpegData: jpegData)) { result in
            switch result {
            case .success(let response): completion(.success(response))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}
