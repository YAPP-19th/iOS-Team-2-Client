//
//  SignupNormalViewModel.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/19.
//

import UIKit
import Combine
import NaverThirdPartyLogin
import Moya
import MapKit

final class SignupViewModel: ViewModel {
    struct Action {
        let fetch = PassthroughSubject<Void, Never>()
        let refresh = PassthroughSubject<Void, Never>()
        let positionFetch = PassthroughSubject<Position, Never>()
        let selectPositionSave = PassthroughSubject<[String], Never>()
        let switchView = PassthroughSubject<ModalControl, Never>()
        let saveResume = PassthroughSubject<Void, Never>()

        // 경력, 프로젝트 이력 뷰에 사용하는 PassthroughSubject
        let firstReuseTextField = PassthroughSubject<String, Never>()
        let leftDatePicker = PassthroughSubject<String, Never>()
        let rightDatePicker = PassthroughSubject<String, Never>()
        let secondReuseTextField = PassthroughSubject<String, Never>()

        // 포트폴리오 뷰에 사용하는 PassthroughSubject
        let porfolioTextField = PassthroughSubject<String, Never>()
    }

    struct State {
        // 네이버 로그인 시 정보 저장
        let naverData = CurrentValueSubject<NaverData?, Never>(nil)
        // Budi 서버 로그인 정보 저장
        let loginUserData = CurrentValueSubject<LoginResponse?, Never>(nil)
        // Budi 서버 포지션 선택 대응 정보 저장
        let positionData = CurrentValueSubject<[String]?, Never>(nil)
        // 앱 내 포지션 선택 정보 저장
        let selectPositionData = CurrentValueSubject<[String]?, Never>(nil)
        // 이력 관리 선택한 뷰 관리 (경력, 프로젝트 이력 뷰)
        let reUseModalView = CurrentValueSubject<ModalControl?, Never>(nil)
        let careerSaveData = CurrentValueSubject<[CareerList]?, Never>([])
        let projectSaveData = CurrentValueSubject<[ProjectList]?, Never>([])
        let portFolioSaveData = CurrentValueSubject<[String]?, Never>([])
        let firstString = CurrentValueSubject<String?, Never>(nil)
        let leftDateString = CurrentValueSubject<String?, Never>(nil)
        let rightDateString = CurrentValueSubject<String?, Never>(nil)
        let secondString = CurrentValueSubject<String?, Never>(nil)
        let portfolioString = CurrentValueSubject<String?, Never>(nil)

        let tableView = CurrentValueSubject<[SectionModel], Never>([SectionModel.init(type: .company, items: []), SectionModel.init(type: .project, items: []), SectionModel.init(type: .portfolio, items: [])])
    }

    let action = Action()
    let state = State()

    private var cancellables = Set<AnyCancellable>()
    private let provider = MoyaProvider<BudiTarget>()
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()

    private(set) lazy var careerIsInvalid = Publishers.CombineLatest4(action.firstReuseTextField, action.leftDatePicker, action.rightDatePicker, action.secondReuseTextField)
        .map { $0.0.count >= 1 && $0.1.count >= 1 && $0.2.count >= 1 && $0.3.count >= 1 ? true : false}
        .eraseToAnyPublisher()

    private(set) lazy var portInvalid = action.porfolioTextField.map { $0.count >= 1 ? true : false }
        .eraseToAnyPublisher()

    init() {
        getNaverInfo()
        getPositions()
        switchView()
        loadTextFields()
        save()
    }

    func save() {
        action.saveResume
            .receive(on: DispatchQueue.main)
            .sink {
                guard let modalView = self.state.reUseModalView.value else { return }
                print(modalView)
                switch modalView {
                case .company:
                    guard let count = self.state.careerSaveData.value?.count else { return }
                    if count != 0 {
                        guard var oldData = self.state.careerSaveData.value else { return }
                        oldData.append(
                            CareerList(description: self.state.secondString.value ?? "",
                                       endDate: self.state.rightDateString.value ?? "",
                                       name: self.state.firstString.value ?? "",
                                       startDate: self.state.rightDateString.value ?? ""))

                        self.state.careerSaveData.send(oldData)
                    } else {
                        self.state.careerSaveData.send([
                            CareerList(description: self.state.secondString.value ?? "",
                                       endDate: self.state.rightDateString.value ?? "",
                                       name: self.state.firstString.value ?? "",
                                       startDate: self.state.rightDateString.value ?? "")
                        ])
                    }
                case .project:
                    guard let count = self.state.projectSaveData.value?.count else { return }
                    if count != 0 {
                        guard var oldData = self.state.projectSaveData.value else { return }
                        oldData.append(
                            ProjectList(description: self.state.secondString.value ?? "",
                                        endDate: self.state.rightDateString.value ?? "",
                                        name: self.state.firstString.value ?? "",
                                        startDate: self.state.rightDateString.value ?? ""))
                        self.state.projectSaveData.send(oldData)
                    } else {
                        self.state.projectSaveData.send([
                            ProjectList(description: self.state.secondString.value ?? "",
                                        endDate: self.state.rightDateString.value ?? "",
                                        name: self.state.firstString.value ?? "",
                                        startDate: self.state.rightDateString.value ?? "")
                        ])
                    }
                case .portfolio:
                    guard let count = self.state.portFolioSaveData.value?.count else { return }
                    if count != 0 {
                        guard var oldData = self.state.portFolioSaveData.value else { return }
                        oldData.append(self.state.portfolioString.value ?? "")
                        self.state.portFolioSaveData.send(oldData)
                    } else {
                        self.state.portFolioSaveData.send([self.state.portfolioString.value ?? ""])
                    }
                }
                print("커리어 데이터 ", self.state.careerSaveData.value?.count ?? 0)
                print("프로젝트 데이터", self.state.projectSaveData.value?.count ?? 0)
                print("포트폴리오 데이터", self.state.portFolioSaveData.value?.count ?? 0)
            }
            .store(in: &cancellables)
    }

    func loadTextFields() {
        action.firstReuseTextField
            .receive(on: DispatchQueue.global())
            .sink { text in
                self.state.firstString.send(text)
            }
            .store(in: &cancellables)

        action.leftDatePicker
            .receive(on: DispatchQueue.global())
            .sink { text in
                self.state.leftDateString.send(text)
            }
            .store(in: &cancellables)

        action.rightDatePicker
            .receive(on: DispatchQueue.global())
            .sink { text in
                self.state.rightDateString.send(text)
            }
            .store(in: &cancellables)

        action.secondReuseTextField
            .receive(on: DispatchQueue.global())
            .sink { text in
                self.state.secondString.send(text)
            }
            .store(in: &cancellables)

        action.porfolioTextField
            .receive(on: DispatchQueue.global())
            .sink { text in
                self.state.portfolioString.send(text)
            }
            .store(in: &cancellables)
    }

    func switchView() {
        action.switchView
            .receive(on: DispatchQueue.global())
            .sink {[weak self] data in
                self?.state.reUseModalView.send(data)
            }
            .store(in: &cancellables)
    }

    func getPositions() {
        action.positionFetch
            .sink(receiveValue: { [weak self] selectedPosition in
                guard let self = self else { return }
                self.provider
                    .requestPublisher(.detailPositions(postion: selectedPosition))
                    .map(APIResponse<[String]>.self)
                    .map(\.data)
                    .sink(receiveCompletion: { [weak self] completion in
                        guard case let .failure(error) = completion else { return }
                        print(completion)
                        self?.state.positionData.send(nil)
                        print(error.localizedDescription)
                    }, receiveValue: { post in
                        self.state.positionData.send(post)
                    })
                    .store(in: &self.cancellables)
            }).store(in: &cancellables)
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
