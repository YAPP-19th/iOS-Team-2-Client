//
//  ChattingViewModel.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/09.
//

import Combine
import Foundation
import Moya
import Firebase

final class ChattingViewModel: ViewModel {
    
    struct Action {
        let fetch = PassthroughSubject<Void, Never>()
        let refresh = PassthroughSubject<Void, Never>()
    }

    struct State {
        let currentUser = CurrentValueSubject<ChatUser?, Never>(nil)
        let oppositeUser = CurrentValueSubject<ChatUser?, Never>(nil)
        
        let messages = CurrentValueSubject<[ChatMessage], Never>([])
        let recentMessages = CurrentValueSubject<[ChatMessage], Never>([])
        
        let postId = CurrentValueSubject<Int, Never>(0)
        let positionName = CurrentValueSubject<String, Never>("")
        let applyId = CurrentValueSubject<Int, Never>(0)
    }
    
    private var listener: ListenerRegistration?

    let action = Action()
    let state = State()
    private var cancellables = Set<AnyCancellable>()
    private let provider = MoyaProvider<ApplyTarget>()
    
    private let manager = ChatManager.shared
    
    // MARK: - Test/Users
    let currentUser = ChatUser(id: "0",
                         username: "현재 유저",
                         position: "iOS 개발자",
                         profileImageUrl: "https://budi.s3.ap-northeast-2.amazonaws.com/post_image/default/education.jpg")
    let oppositeUser = ChatUser(id: "21",
                         username: "상대 유저",
                         position: "UX 디자이너",
                         profileImageUrl: "https://budi.s3.ap-northeast-2.amazonaws.com/post_image/default/dating.jpg")

    init() {
        state.currentUser.value = currentUser
        state.oppositeUser.value = oppositeUser
        fetchCurrentUserInfo()
        
        // MARK: - 테스트를 위해 모든 메세지 삭제
//        manager.removeAllMessages("0", "21")

        fetchRecentMessages()
    }
}

extension ChattingViewModel {
    
    // MARK: - Applies 조회
    func getApplyId() {
        // MARK: - 이후 AccessToken으로 변경
        let accessToken = String.testAccessToken
        var position = ""
        let postId = state.postId.value
        
        let positionName = state.positionName.value
        if Position.developer.positionList.contains(positionName) {
            position = "developer"
        } else if Position.designer.positionList.contains(positionName) {
            position = "designer"
        } else {
            position = "planner"
        }
        
        // MARK: - 지원자들 조회 -> applyId 얻은 후 state에 저장
        provider.request(.applies(accessToken: accessToken, position: position, postId: postId)) { result in
            switch result {
            case .success(let response):
                do {
                    guard let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any], let data = json["data"] else { return }
                    let dict = try JSONSerialization.data(withJSONObject: data)
                    let appliesResults = try JSONDecoder().decode([AppliesResult].self, from: dict)
                    
                    guard let stringId = self.state.currentUser.value?.id, let id = Int(stringId), let appliesResult = appliesResults.filter({ $0.applyer.id == Int(id) }).first else { return }
                                        
                    let applyId = appliesResult.applyId
                    self.state.applyId.value = applyId
                } catch {}
            case .failure(let error): print(error.localizedDescription)
            }
        }
    }
    
    func acceptApply(_ completion: @escaping (Result<Moya.Response, Error>) -> Void) {
        // MARK: - 이후 AccessToken으로 변경
        let accessToken = String.testAccessToken
        let applyId = state.applyId.value
        
        provider.request(.acceptApply(accessToken: accessToken, applyId: applyId)) { result in
            switch result {
            case .success(let response): completion(.success(response))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    // MARK: - Message
    func fetchRecentMessages() {
        guard let currentUid = currentUser.id else { return }

        let query = FirebaseCollection.recentMessages(uid: currentUid).ref
            .order(by: "timestamp", descending: true)
        
        query.getDocuments { snapshot, error in
            if let error = error { print("error: \(error.localizedDescription)") }
            guard let documents = snapshot?.documents else { return }
            let recentMessages = documents.compactMap { try? $0.data(as: ChatMessage.self) }
            self.state.recentMessages.value = recentMessages
        }
    }
    
    func fetchMessages() {
        guard let currentUid = state.currentUser.value?.id  else { return }
        guard let oppositeUid = state.oppositeUser.value?.id else { return }
        
        let query = FirebaseCollection.messages.ref
            .document(currentUid)
            .collection(oppositeUid)
            .order(by: "timestamp", descending: false)
        
        listener?.remove()
        
        listener = query.addSnapshotListener { [weak self] snapshot, _ in
            guard let self = self else { return }
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }
            let newMessages = changes.compactMap { try? $0.document.data(as: ChatMessage.self) }
            self.state.messages.value.append(contentsOf: newMessages)
        }
        
        query.getDocuments { [weak self] snapshot, _ in
            guard let self = self else { return }
            guard let documents = snapshot?.documents else { return }
            let messages = documents.compactMap { try? $0.data(as: ChatMessage.self) }
            self.state.messages.value = messages
            if let firstMessage = messages.first {
                self.state.postId.value = firstMessage.postId
                self.state.positionName.value = firstMessage.positionName
                self.getApplyId()
            }
        }
    }
}

// MARK: - User
private extension ChattingViewModel {
    func fetchCurrentUserInfo() {
        guard let currentUid = currentUser.id  else { return }
        
        manager.fetchUserInfo(currentUid) { [weak self] user in
            guard let self = self else { return }
            self.state.currentUser.value = user
        }
    }
}
