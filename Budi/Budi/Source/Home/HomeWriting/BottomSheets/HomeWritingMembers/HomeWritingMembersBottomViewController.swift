//
//  HomeWritingMembersBottomViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/13.
//

import UIKit
import Combine
import CombineCocoa

final class HomeWritingMembersBottomViewController: UIViewController {
    
    @IBOutlet private weak var backgroundButton: UIButton!
    
    @IBOutlet private weak var completeView: UIView!
    @IBOutlet private weak var completeButton: UIButton!
    
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var bottomViewTopConstraint: NSLayoutConstraint!
    
    private var isBottomViewShown: Bool = false
    
    weak var coordinator: HomeCoordinator?
    private let viewModel: HomeWritingViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(nibName: String?, bundle: Bundle?, viewModel: HomeWritingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        completeView.layer.addBorderTop()
        configureCollectionView()
        bindViewModel()
        setPublisher()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showBottomView()
    }
}

private extension HomeWritingMembersBottomViewController {
    func bindViewModel() {
        backgroundButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.hideBottomView()
            }.store(in: &cancellables)
    }
    
    func setPublisher() {
    }
}

private extension HomeWritingMembersBottomViewController {
    func showBottomView() {
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear) { [weak self] in
            guard let self = self else { return }
            self.bottomViewTopConstraint.constant -= 500
            self.view.layoutIfNeeded()
        }
        animator.addCompletion { [weak self] _ in
            self?.isBottomViewShown = true
        }
        animator.startAnimation()
    }
    
    func hideBottomView() {
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear) { [weak self] in
            guard let self = self else { return }
            self.bottomViewTopConstraint.constant += 500
            self.view.layoutIfNeeded()
        }
        animator.addCompletion { [weak self] _ in
            self?.dismiss(animated: false, completion: nil)
            self?.isBottomViewShown = false
        }
        animator.startAnimation()
    }
}

// MARK: - CollectionView
extension HomeWritingMembersBottomViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        [HomeWritingMembersPartBottomCell.self, HomeWritingMembersDetailPartBottomCell.self, HomeWritingMembersCountBottomCell.self].forEach {
            collectionView.register(.init(nibName: $0.identifier, bundle: nil), forCellWithReuseIdentifier: $0.identifier)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingMembersPartBottomCell.identifier, for: indexPath) as? HomeWritingMembersPartBottomCell else { return UICollectionViewCell() }
            return cell
        case 1: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingMembersDetailPartBottomCell.identifier, for: indexPath) as? HomeWritingMembersDetailPartBottomCell else { return UICollectionViewCell() }
            return cell
        case 2: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingMembersCountBottomCell.identifier, for: indexPath) as? HomeWritingMembersCountBottomCell else { return UICollectionViewCell() }
            return cell
        default: break
        }
        
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: collectionView.bounds.width, height: 0)
        
        switch indexPath.row {
        case 0: size.height = 166
        case 1: size.height = 145
        case 2: size.height = 200
        default: break
        }
        
        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}
