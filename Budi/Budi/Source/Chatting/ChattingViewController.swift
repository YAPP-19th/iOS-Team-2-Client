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

    @IBOutlet weak var collecitonView: UICollectionView!
    
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
        viewModel.state.recentMessages
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
            }).store(in: &cancellables)
    }
    
    func setPublisher() {
    }
}

// MARK: - CollectionView
extension ChattingViewController: UICollectionViewDataSource {
    private func configureCollectionView() {
        collecitonView.dataSource = self
        collecitonView.delegate = self
        collecitonView.register(.init(nibName: ChattingCell.identifier, bundle: nil), forCellWithReuseIdentifier: ChattingCell.identifier)
        collecitonView.backgroundColor = .systemGroupedBackground
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChattingCell.identifier, for: indexPath) as UICollectionViewCell
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.showDetail()
    }
}

extension ChattingViewController: UICollectionViewDelegate {

}

extension ChattingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 97)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
}

private extension ChattingViewController {
    func configureNavigationBar() {
        let notifyButton = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: nil)
        notifyButton.tintColor = .black

        navigationItem.rightBarButtonItem = notifyButton
        title = "채팅"
    }
}
