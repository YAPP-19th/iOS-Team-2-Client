//
//  HomeDetailViewModel.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/25.
//

import Combine
import Foundation
import Moya

protocol ViewModel {

    associatedtype Action
    associatedtype State

    var action: Action { get }
    var state: State { get }
}

final class HomeDetailViewModel: ViewModel {

    struct Action {
        let fetch = PassthroughSubject<Void, Never>()
        let refresh = PassthroughSubject<Void, Never>()
    }

    struct State {
        let posts = CurrentValueSubject<[Post], Never>([])
    }

    let action = Action()
    let state = State()
    private var cancellables = Set<AnyCancellable>()
    private let provider = MoyaProvider<PostTarget>()

    init() {
    }
}
