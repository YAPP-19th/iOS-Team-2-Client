//
//  ChattingViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit
import Moya
import Combine
import CombineCocoa

final class ChattingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let manager = ChatManager.shared
    weak var coordinator: ChattingCoordinator?
    private let viewModel: ChattingViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ChattingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    init?(coder: NSCoder, viewModel: ChattingViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("This viewController must be init with viewModel")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setPublisher()
        configureNavigationBar()
        configureCollectionView()
    }
}

private extension ChattingViewController {
    func bindViewModel() {
        viewModel.state.currentUser
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] currentUser in
                self?.collectionView.reloadData()
            }).store(in: &cancellables)
        
        viewModel.state.recentMessages
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] recentMessages in
                print("mainVC recentMessages: \(recentMessages)")
                self?.collectionView.reloadData()
            }).store(in: &cancellables)
    }
    
    func setPublisher() {
    }
    
    func configureNavigationBar() {
        let notifyButton = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: nil)
        notifyButton.tintColor = .black

        navigationItem.rightBarButtonItem = notifyButton
        title = "채팅"
    }
}

// MARK: - CollectionView
extension ChattingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(.init(nibName: ChattingCell.identifier, bundle: nil), forCellWithReuseIdentifier: ChattingCell.identifier)
        collectionView.backgroundColor = .systemGroupedBackground
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.state.recentMessages.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChattingCell.identifier, for: indexPath) as? ChattingCell,
              let currentUser = viewModel.state.currentUser.value else { return UICollectionViewCell() }
        
        let message = viewModel.state.recentMessages.value[indexPath.row]
        let isFromCurrentUser = message.senderId == currentUser.id
        cell.configureUI(message, isFromCurrentUser)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let currentUser = viewModel.state.currentUser.value, let currentUid = currentUser.id else { return }
        
        let message = viewModel.state.recentMessages.value[indexPath.row]
        let oppositeUid = (message.recipientId == currentUid) ? message.senderId : message.recipientId
        
        manager.fetchUserInfo(oppositeUid) { [weak self] oppositeUser in
            guard let self = self else { return }
            self.viewModel.state.oppositeUser.value = oppositeUser
            self.viewModel.fetchMessages()
            self.coordinator?.showDetail(self.viewModel)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 97)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
}
