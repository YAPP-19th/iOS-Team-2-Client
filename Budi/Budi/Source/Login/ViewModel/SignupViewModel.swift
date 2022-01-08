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
import AuthenticationServices

final class SignupViewModel: ViewModel {
    struct Action {
        let fetch = PassthroughSubject<Void, Never>()
        let refresh = PassthroughSubject<Void, Never>()
        let positionFetch = PassthroughSubject<Position, Never>()
        let switchView = PassthroughSubject<ModalControl, Never>()
        let checkSameId = PassthroughSubject<String, Never>()
        let positionSelect = PassthroughSubject<String, Never>()
        let positionDeSelect = PassthroughSubject<String, Never>()

        let fetchSignupInfoData = PassthroughSubject<Void, Never>()
        let fetchSignupPortfolioData = PassthroughSubject<Void, Never>()
        let appendSectionData = PassthroughSubject<ModalControl, Never>()
        let postCreateInfo = PassthroughSubject<Void, Never>()
        let setSignupInfoData = PassthroughSubject<Void, Never>()
        let setSignupPortfolioData = PassthroughSubject<Void, Never>()
        // 포트폴리오 뷰에 사용하는 PassthroughSubject
        let cellSelectIndex = PassthroughSubject<[Int], Never>()
        let loadEditData = PassthroughSubject<Void, Never>()
        let deleteSignupInfoData = PassthroughSubject<Void, Never>()
        let LoginStatusCheck = PassthroughSubject<Void, Never>()
    }

    struct State {
        // 클라이언트 로그인 시 정보 저장
        var loginUserInfo: LoginUserInfo? = nil
        // Budi 서버 로그인 정보 저장
        let budiLoginUserData = CurrentValueSubject<String?, Never>(nil)
        // Budi 서버 포지션 선택 대응 정보 저장
        let positionData = CurrentValueSubject<[String]?, Never>(nil)
        let checkIdStatus = CurrentValueSubject<Bool?, Never>(nil)
        let positionSelectData = CurrentValueSubject<[String], Never>([])
        // 앱 내 포지션 선택 정보 저장
        let selectPositionData = CurrentValueSubject<[String]?, Never>(nil)
        // 이력 관리 선택한 뷰 관리 (경력, 프로젝트 이력 뷰)
        let reUseModalView = CurrentValueSubject<ModalControl?, Never>(nil)
        let selectedPosition = CurrentValueSubject<Position, Never>(.developer)

        let writedInfoData = CurrentValueSubject<SignupInfoModel?, Never>(
            SignupInfoModel(mainName: "", startDate: "", endDate: "", nowWorks: false, description: "", porflioLink: "")
        )
        let writedPortfolioData = CurrentValueSubject<SignupInfoModel, Never>(
            SignupInfoModel(mainName: "", startDate: "", endDate: "", nowWorks: false, description: "", porflioLink: "")
        )

        let sectionData = CurrentValueSubject<[HistorySectionModel], Never>(
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

        let selectIndex = CurrentValueSubject<[Int], Never>([])

        let editData = CurrentValueSubject<Item?, Never>(nil)

        let signUpPersonalInfoData = CurrentValueSubject<PersonalInfo, Never>(PersonalInfo(nickName: "", location: "", description: ""))

        let userInfoUploadStatus = CurrentValueSubject<String?, Never>(nil)

        let loginStatusData = CurrentValueSubject<LoginUserDetail?, Never>(nil)
    }

    let action = Action()
    var state = State()

    private var cancellables = Set<AnyCancellable>()
    private let provider = MoyaProvider<BudiTarget>()
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()

    init() {
        getPositions()
        switchView()
        fetchSectionData()
        appendSectionData()
        selectCellIndex()
        postCreateInfo()
        setSignupModel()
        signUpcellCRUD()
        postitionFunction()
        loginStatusCheck()
    }

    func loginStatusCheck() {
        action.LoginStatusCheck
            .receive(on: DispatchQueue.global())
            .sink { [weak self] _ in
                guard let self = self else { return }
                let loginModel = LoginCheckModel(accessToken: UserDefaults.standard.string(forKey: "accessToken") ?? "")

                self.provider
                    .requestPublisher(.signUpStatusCheck(memberId: UserDefaults.standard.integer(forKey: "memberId")))
                    .map(APIResponse<LoginUserDetail>.self)
                    .map(\.data)
                    .sink(receiveCompletion: { [weak self] completion in
                        guard let self = self else { return }
                        switch completion {
                        case .failure(let error):
                            print(error.localizedDescription)
                        case .finished:
                            break
                        }
                        self.state.loginStatusData.send(nil)
                    }, receiveValue: { post in
                        print("이게 아닌가?",post.id)
                        print("ㅇㅇㅇ",post.nickName)
                        print(post)
                        if post.nickName == "" {
                            self.state.loginStatusData.send(nil)
                        } else {
                            let user = LoginUserDetail(id: post.id,
                                                       imageUrl: post.imageUrl,
                                                       nickName: post.nickName,
                                                       level: post.level,
                                                       positions: post.positions,
                                                       likeCount: post.likeCount,
                                                       projectList: post.projectList,
                                                       portfolioList: post.portfolioList,
                                                       isLikedFromCurrentMember: post.isLikedFromCurrentMember
                            )
                            self.state.loginStatusData.send(user)
                        }
                    })
                    .store(in: &self.cancellables)

            }
            .store(in: &cancellables)
    }

    func postitionFunction() {
        action.positionSelect
            .receive(on: DispatchQueue.main)
            .sink { [weak self] position in
                guard let self = self else { return }
                var oldPostitionList = self.state.positionSelectData.value
                let flag = oldPostitionList.contains(position)
                if !flag {
                    oldPostitionList.insert(position, at: oldPostitionList.count)
                    self.state.positionSelectData.send(oldPostitionList)
                }
            }
            .store(in: &cancellables)

        action.positionDeSelect
            .receive(on: DispatchQueue.main)
            .sink { [weak self] position in
                guard let self = self else { return }
                var oldPositionList = self.state.positionSelectData.value
                guard let index = oldPositionList.firstIndex(of: position) else { return }
                print(index)
                oldPositionList.remove(at: index)
                self.state.positionSelectData.send(oldPositionList)
            }
            .store(in: &cancellables)
    }

    func signUpcellCRUD() {
        action.loadEditData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                let section = self.state.selectIndex.value[0]
                let index = self.state.selectIndex.value[1]
                let data = self.state.sectionData.value[section].items[index]
                print(data)
                self.state.editData.send(data)
            }
            .store(in: &cancellables)

        action.deleteSignupInfoData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                let section = self.state.selectIndex.value[0]
                let index = self.state.selectIndex.value[1]
                var deleteData = self.state.sectionData.value[section].items
                var updateData = self.state.sectionData.value
                let filter = self.state.sectionData.value[section].type
                deleteData.remove(at: index)
                updateData[section].items = deleteData
                self.state.sectionData.send(updateData)
                if deleteData.count == 0 {
                    self.action.appendSectionData.send(filter)
                }
            }
            .store(in: &cancellables)
    }

    func setSignupModel() {
        action.setSignupInfoData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.state.writedInfoData.send(SignupInfoModel(mainName: "", startDate: "", endDate: "", nowWorks: false, description: "", porflioLink: ""))
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

                    let item = Item(itemInfo: ItemInfo(isInclude: false, buttonTitle: "경력을 추가해보세요"), description: "", endDate: "", name: "", nowWork: false, startDate: "", portfolioLink: "")
                    selectItems.insert(item, at: selectItems.count)
                    oldValue[index].items = selectItems
                    self.state.sectionData.send(oldValue)
                    print(self.state.sectionData.value[index].items.count)
                case .project:

                    let index = self.state.sectionData.value.firstIndex { $0.type == .project }
                    guard let index = index else { return }
                    var oldValue = self.state.sectionData.value
                    var selectItems = self.state.sectionData.value[index].items

                    let item = Item(itemInfo: ItemInfo(isInclude: false, buttonTitle: "프로젝트 이력을 추가해보세요"), description: "", endDate: "", name: "", nowWork: false, startDate: "", portfolioLink: "")

                    selectItems.insert(item, at: selectItems.count)
                    oldValue[index].items = selectItems
                    self.state.sectionData.send(oldValue)
                    print(self.state.sectionData.value[index].items.count)
                case .portfolio:

                    let index = self.state.sectionData.value.firstIndex { $0.type == .portfolio }
                    guard let index = index else { return }
                    var oldValue = self.state.sectionData.value
                    var selectItems = self.state.sectionData.value[index].items

                    let item = Item(itemInfo: ItemInfo(isInclude: false, buttonTitle: "포트폴리오를 추가해보세요"), description: "", endDate: "", name: "", nowWork: false, startDate: "", portfolioLink: "")

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
                changeData.nowWork = data.nowWorks
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
        action.checkSameId
            .receive(on: DispatchQueue.global())
            .sink(receiveValue: { [weak self] name in
                guard let self = self else { return }
                if name == "" {
                    self.state.checkIdStatus.send(nil)
                } else {
                    self.provider
                        .requestPublisher(.checkDuplicateName(name: name))
                        .map(APIResponse<NameDuplication>.self)
                        .map(\.data)
                        .sink(receiveCompletion: { [weak self] completion in
                            switch completion {
                            case .failure(let error):
                                print(error.localizedDescription)
                            case .finished:
                                break
                            }
                            self?.state.checkIdStatus.send(nil)
                        }, receiveValue: { post in
                            self.state.checkIdStatus.send(post.exist)
                        })
                        .store(in: &self.cancellables)
                }
            })
            .store(in: &cancellables)

        action.positionFetch
            .sink(receiveValue: { [weak self] selectedPosition in
                guard let self = self else { return }
                self.provider
                    .requestPublisher(.detailPositions(position: selectedPosition))
                    .map(APIResponse<[String]>.self)
                    .map(\.data)
                    .sink(receiveCompletion: { [weak self] completion in
                        guard case let .failure(error) = completion else { return }
                        print(completion)
                        self?.state.positionData.send(nil)
                        print(error.localizedDescription)
                    }, receiveValue: { post in
                        print("왜 안들어옴", post)
                        self.state.positionData.send(post)
                        self.state.selectedPosition.send(selectedPosition)
                    })
                    .store(in: &self.cancellables)
            }).store(in: &cancellables)
    }

    func postCreateInfo() {
        action.postCreateInfo
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                let accsessToken = self.state.budiLoginUserData.value
                let projectList = self.state.sectionData.value[0].items
                let portfolioList = self.state.sectionData.value[1].items
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
                    uploadPortfolioList.append(portfolio.portfolioLink)
                }

                let param = CreateInfo(
                    basePosition: self.state.selectedPosition.value.integerValue,
                    careerList: uploadCareerList,
                    description: self.state.signUpPersonalInfoData.value.description,
                    memberAddress: self.state.signUpPersonalInfoData.value.location,
                    nickName: self.state.signUpPersonalInfoData.value.nickName,
                    portfolioLink: uploadPortfolioList,
                    positionList: self.state.selectPositionData.value ?? [],
                    projectList: uploadProjectList
                )
                print("파라미터 ", param)
                guard let accsessToken = accsessToken else { return }
                self.provider.requestPublisher(.createInfo(acessToken: accsessToken, param: param))
                    .map(UserInfoUploadSuccess.self)
                    .sink(receiveCompletion: { [weak self] completion in
                        guard let self = self else { return }
                        guard case let .failure(error) = completion else { return }
                        self.state.userInfoUploadStatus.send(nil)
                        print(error.localizedDescription)

                    }, receiveValue: { post in
                        UserDefaults.standard.set(post.data.memberId, forKey: "memberId")
                        UserDefaults.standard.set(accsessToken, forKey: "accessToken")
                        self.state.userInfoUploadStatus.send(post.message)
                        NotificationCenter.default.post(name: Notification.Name("LoginSuccessed"), object: nil)

                    })
                    .store(in: &self.cancellables)
            })
            .store(in: &cancellables)
    }

    func getAppleLoginInfo() {

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
    }

    // MARK: - Budi 서버에 POST 보내는 viewModel
    func pushServer() {
        print("여기서 안넘어오는듯")
        guard let id = state.loginUserInfo?.id else { return }
        print("넘어온 id",id)
        let replaceId = id.replacingOccurrences(of: ".", with: "")
        let loginData = BudiLogin(loginId: "\(replaceId)")
        guard let uploadData = try? JSONEncoder().encode(loginData) else { return }

        guard let url = URL(string: .baseURLString+"/auth/login") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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

                self.state.budiLoginUserData.send(decodeData.data.accessToken)
                print("로그인 유저 아이디 :", decodeData.data.userId)
                print("로그인 고유 토큰 :", decodeData.data.accessToken)
                UserDefaults.standard.set(decodeData.data.memberId, forKey: "memberId")
                UserDefaults.standard.set(decodeData.data.accessToken, forKey: "accessToken")
                print("저장된 엑세스 토큰", UserDefaults.standard.string(forKey: "accessToken"))
                print("저장된 멤버 ID", UserDefaults.standard.integer(forKey: "memberId"))
            } catch {
                print("Error")
            }
        }
        .resume()

    }
}
