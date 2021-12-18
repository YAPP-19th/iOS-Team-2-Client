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
        let fetchSignupInfoData = PassthroughSubject<Void, Never>()
        let fetchSignupPortfolioData = PassthroughSubject<Void, Never>()
        let appendSectionData = PassthroughSubject<ModalControl, Never>()
        let postCreateInfo = PassthroughSubject<Void, Never>()

        let setSignupInfoData = PassthroughSubject<Void, Never>()
        let setSignupPortfolioData = PassthroughSubject<Void, Never>()
        // 포트폴리오 뷰에 사용하는 PassthroughSubject
        let cellSelectIndex = PassthroughSubject<[Int], Never>()
    }

    struct State {
        // 네이버 로그인 시 정보 저장
        let naverData = CurrentValueSubject<NaverData?, Never>(nil)
        // Budi 서버 로그인 정보 저장
        let budiLoginUserData = CurrentValueSubject<String?, Never>(nil)
        // Budi 서버 포지션 선택 대응 정보 저장
        let positionData = CurrentValueSubject<[String]?, Never>(nil)
        // 앱 내 포지션 선택 정보 저장
        let selectPositionData = CurrentValueSubject<[String]?, Never>(nil)
        // 이력 관리 선택한 뷰 관리 (경력, 프로젝트 이력 뷰)
        let reUseModalView = CurrentValueSubject<ModalControl?, Never>(nil)

        let writedInfoData = CurrentValueSubject<SignupInfoModel?, Never>(
            SignupInfoModel(mainName: "", startDate: "", endDate: "", description: "", porflioLink: "")
        )
        let writedPortfolioData = CurrentValueSubject<SignupInfoModel, Never>(
            SignupInfoModel(mainName: "", startDate: "", endDate: "", description: "", porflioLink: "")
        )

        let sectionData = CurrentValueSubject<[HistorySectionModel], Never>(
            [
                HistorySectionModel.init(
                    type: .career,
                    sectionTitle: ModalControl.career.stringValue ,
                    items: [
                        Item(itemInfo: ItemInfo(isInclude: false, buttonTitle: "경력을 추가해보세요"),
                             description: "", endDate: "", name: "", startDate: "", portfolioLink: "")
                    ]),

                HistorySectionModel.init(
                    type: .project,
                    sectionTitle: ModalControl.project.stringValue ,
                    items: [
                        Item(itemInfo: ItemInfo(isInclude: false, buttonTitle: "프로젝트 이력을 추가해보세요"),
                             description: "", endDate: "", name: "", startDate: "", portfolioLink: "")]),

                HistorySectionModel.init(
                    type: .portfolio,
                    sectionTitle: ModalControl.portfolio.stringValue ,
                    items: [
                        Item(itemInfo: ItemInfo(isInclude: false, buttonTitle: "포트폴리오를 추가해보세요"),
                             description: "", endDate: "", name: "", startDate: "", portfolioLink: "")])
            ])

        let selectIndex = CurrentValueSubject<[Int], Never>([])
    }

    let action = Action()
    let state = State()

    private var cancellables = Set<AnyCancellable>()
    private let provider = MoyaProvider<BudiTarget>()
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()

    init() {
        getNaverInfo()
        getPositions()
        switchView()
        fetchSectionData()
        appendSectionData()
        selectCellIndex()
        postCreateInfo()
        setSignupModel()

    }

    func setSignupModel() {
        action.setSignupInfoData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.state.writedInfoData.send(SignupInfoModel(mainName: "", startDate: "", endDate: "", description: "", porflioLink: ""))
            }
            .store(in: &cancellables)
    }

    func selectCellIndex() {
        action.cellSelectIndex
            .receive(on: DispatchQueue.main)
            .sink { data in
                self.state.selectIndex.send(data)
            }
            .store(in: &cancellables)

    }

    // MARK: - 테이블 뷰 셀 업데이트 viewModel
    func appendSectionData() {
        action.appendSectionData
            .receive(on: DispatchQueue.main)
            .sink { filter in
                switch filter {
                case .career:

                    let index = self.state.sectionData.value.firstIndex { $0.type == .career }
                    guard let index = index else { return }
                    var oldValue = self.state.sectionData.value
                    var selectItems = self.state.sectionData.value[index].items

                    let item = Item(itemInfo: ItemInfo(isInclude: false, buttonTitle: "경력을 추가해보세요"), description: "", endDate: "", name: "", startDate: "", portfolioLink: "")
                    selectItems.insert(item, at: selectItems.count)
                    oldValue[index].items = selectItems
                    self.state.sectionData.send(oldValue)
                    print(self.state.sectionData.value[index].items.count)
                case .project:

                    let index = self.state.sectionData.value.firstIndex { $0.type == .project }
                    guard let index = index else { return }
                    var oldValue = self.state.sectionData.value
                    var selectItems = self.state.sectionData.value[index].items

                    let item = Item(itemInfo: ItemInfo(isInclude: false, buttonTitle: "프로젝트 이력을 추가해보세요"), description: "", endDate: "", name: "", startDate: "", portfolioLink: "")

                    selectItems.insert(item, at: selectItems.count)
                    oldValue[index].items = selectItems
                    self.state.sectionData.send(oldValue)
                    print(self.state.sectionData.value[index].items.count)
                case .portfolio:

                    let index = self.state.sectionData.value.firstIndex { $0.type == .portfolio }
                    guard let index = index else { return }
                    var oldValue = self.state.sectionData.value
                    var selectItems = self.state.sectionData.value[index].items

                    let item = Item(itemInfo: ItemInfo(isInclude: false, buttonTitle: "포트폴리오를 추가해보세요"), description: "", endDate: "", name: "", startDate: "", portfolioLink: "")

                    selectItems.insert(item, at: selectItems.count)
                    oldValue[index].items = selectItems
                    self.state.sectionData.send(oldValue)
                    print(self.state.sectionData.value[index].items.count)
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - 이력관리 저장 viewModel
    func fetchSectionData() {
        action.fetchSignupInfoData
            .receive(on: DispatchQueue.main)
            .sink {
                let section = self.state.selectIndex.value[0]
                let index = self.state.selectIndex.value[1]

                var oldData = self.state.sectionData.value
                var changeData = self.state.sectionData.value[section].items[index]
                guard let data = self.state.writedInfoData.value else { return }
                changeData.itemInfo.isInclude = true
                changeData.name = data.mainName
                changeData.startDate = data.startDate
                changeData.endDate = data.endDate
                changeData.description = data.description
                changeData.portfolioLink = data.porflioLink
                print("저장할 때", changeData.name, changeData.portfolioLink)
                oldData[section].items[index] = changeData
                self.state.sectionData.send(oldData)
            }
            .store(in: &cancellables)
    }

    // MARK: - 경력, 프로젝트 이력 모달 뷰 전환용 viewModel
    func switchView() {
        action.switchView
            .receive(on: DispatchQueue.global())
            .sink {[weak self] data in
                self?.state.reUseModalView.send(data)
            }
            .store(in: &cancellables)
    }

    // MARK: - 포지션 GET viewModel
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

    func postCreateInfo() {
        action.postCreateInfo
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                let accsessToken = self.state.budiLoginUserData.value
                print("엑세스", accsessToken)
                let careerList = self.state.sectionData.value[0].items
                let param = CreateInfo(
                    basePosition: 0,
                    careerList: [
                        CareerList(companyName: careerList[0].name,
                                   careerListDescription: "empty",
                                   endDate: careerList[0].endDate,
                                   memberID: 0,
                                   nowWorks: false,
                                   startDate: careerList[0].startDate,
                                   teamName: careerList[0].description,
                                   workRequestList: [TList(tListDescription: "", endDate: "", name: "", startDate: "")])
                    ],
                    createInfoDescription: "열심히 해봐요!",
                    memberAddress: "서울시 강남구",
                    nickName: "NickName",
                    portfolioLink: ["string"],
                    positionList: ["string"],
                    projectList: [TList(tListDescription: "", endDate: "", name: "", startDate: "")]
                )

                self.provider.requestPublisher(.createInfo(acessToken: accsessToken ?? "nil", param: param), callbackQueue: .global())
                    .sink(receiveCompletion: { [weak self] completion in
                        guard case let .failure(error) = completion else { return }
                        self?.state.positionData.send(nil)
                        print("에러", error.localizedDescription)
                    }, receiveValue: {  post in
                        print("dsfds", post)
                    })
                    .store(in: &self.cancellables)
            })
            .store(in: &cancellables)
    }

    // MARK: - 네이버 로그인 viewModel
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

    // MARK: - Budi 서버에 POST 보내는 viewModel
    func pushServer() {
        guard let id = state.naverData.value?.id else { return }
        let loginData = BudiLogin(loginId: id, name: state.naverData.value?.name, email: state.naverData.value?.email)
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
                        let decodeData = try JSONDecoder().decode(APIResponse<BudiLoginResponse>.self, from: data)
                        self.state.budiLoginUserData.send(decodeData.data.userId)
                        print("로그인 데이터 :", self.state.budiLoginUserData.value)
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
