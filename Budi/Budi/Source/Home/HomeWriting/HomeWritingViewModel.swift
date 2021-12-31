//
//  HomeWritingViewModel.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/07.
//

import Combine
import Foundation
import Moya

final class HomeWritingViewModel: ViewModel {
    
    struct Action {
        let fetch = PassthroughSubject<Void, Never>()
        let refresh = PassthroughSubject<Void, Never>()
    }

    struct State {
        let defaultImageUrls = CurrentValueSubject<[String], Never>([])
        let parts = CurrentValueSubject<[String], Never>([])
        let developerPositions = CurrentValueSubject<[String], Never>([])
        let designerPositions = CurrentValueSubject<[String], Never>([])
        let productManagerPositions = CurrentValueSubject<[String], Never>([])
        
        let selectedImageUrl = CurrentValueSubject<String?, Never>(nil)
        let name = CurrentValueSubject<String?, Never>(nil)
        let part = CurrentValueSubject<String?, Never>(nil)
        let startDate = CurrentValueSubject<Date?, Never>(nil)
        let endDate = CurrentValueSubject<Date?, Never>(nil)
        let area = CurrentValueSubject<String?, Never>(nil)
        let recruitingPositions = CurrentValueSubject<[RecruitingPosition], Never>([])
        let isOnline = CurrentValueSubject<Bool?, Never>(nil)
        let description = CurrentValueSubject<String?, Never>(nil)
    }
    
    let action = Action()
    let state = State()
    private var cancellables = Set<AnyCancellable>()
    private let provider = MoyaProvider<BudiTarget>()
    
    func createPost(_ accessToken: String, _ param: PostRequest, _ completion: @escaping (Result<Moya.Response, Error>) -> Void) {
        print("param is \(param)")
        
        provider.request(.createPost(accessToken: accessToken, param: param)) { response in
            switch response {
            case .success(let response):
                completion(.success(response))
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    init() {
        action.fetch
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                
                self.provider
                    .requestPublisher(.postDefaultImageUrls)
                    .map(APIResponse<[String]>.self)
                    .map(\.data)
                    .sink(receiveCompletion: { _ in
                    }, receiveValue: { [weak self] defaultImageUrls in
                        self?.state.defaultImageUrls.send(defaultImageUrls)
                    })
                    .store(in: &self.cancellables)
                
                self.provider
                    .requestPublisher(.postCategory)
                    .map(APIResponse<[String]>.self)
                    .map(\.data)
                    .sink(receiveCompletion: { _ in
                    }, receiveValue: { [weak self] postCategory in
                        self?.state.parts.send(postCategory)
                    })
                    .store(in: &self.cancellables)
                
                self.provider
                    .requestPublisher(.detailPositions(postion: .developer))
                    .map(APIResponse<[String]>.self)
                    .map(\.data)
                    .sink(receiveCompletion: { _ in
                    }, receiveValue: { [weak self] positions in
                        self?.state.developerPositions.send(!positions.isEmpty ? positions : ["iOS 개발"])
                    })
                    .store(in: &self.cancellables)
                
                self.provider
                    .requestPublisher(.detailPositions(postion: .designer))
                    .map(APIResponse<[String]>.self)
                    .map(\.data)
                    .sink(receiveCompletion: { _ in
                    }, receiveValue: { [weak self] positions in
                        self?.state.designerPositions.send(!positions.isEmpty ? positions : ["?디자인"])
                    })
                    .store(in: &self.cancellables)
                
                self.provider
                    .requestPublisher(.detailPositions(postion: .productManager))
                    .map(APIResponse<[String]>.self)
                    .map(\.data)
                    .sink(receiveCompletion: { _ in
                    }, receiveValue: { [weak self] positions in
                        self?.state.productManagerPositions.send(!positions.isEmpty ? positions : ["?기획"])
                    })
                    .store(in: &self.cancellables)
                
            }).store(in: &cancellables)

        action.refresh
            .sink { [weak self] _ in
                self?.action.fetch.send(())
            }.store(in: &cancellables)

        action.fetch.send(())
    }
}
