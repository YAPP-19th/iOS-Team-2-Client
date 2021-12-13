//
//  HomeWritingImageBottomViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/13.
//

import UIKit
import Combine
import CombineCocoa

final class HomeWritingImageBottomViewController: UIViewController {
    
    @IBOutlet private var backgroundView: UIView!
    
    @IBOutlet private weak var completeView: UIView!
    @IBOutlet private weak var completeButton: UIButton!
    
    @IBOutlet private weak var bottomView: UIStackView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var myAlbumButton: UIButton!
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
        configureCollectionView()
        completeView.layer.addBorderTop()
        bindViewModel()
        setPublisher()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateBottomView()
    }
}

private extension HomeWritingImageBottomViewController {
    func bindViewModel() {
    }
    
    func setPublisher() {
        myAlbumButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                print("내 앨범에서 추가")
            }.store(in: &cancellables)
    }
}

private extension HomeWritingImageBottomViewController {
    func animateBottomView() {
        isBottomViewShown ? hideBottomView() : showBottomView()
    }
    
    func showBottomView() {
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear) { [weak self] in
            guard let self = self else { return }
            self.bottomViewTopConstraint.constant -= (self.bottomView.bounds.height - 24)
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
            self.bottomViewTopConstraint.constant += (self.bottomView.bounds.height - 24)
            self.view.layoutIfNeeded()
        }
        animator.addCompletion { [weak self] _ in
            self?.isBottomViewShown = true
        }
        animator.startAnimation()
    }
}

// MARK: - CollectionView
extension HomeWritingImageBottomViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(.init(nibName: HomeWritingImageBottomCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeWritingImageBottomCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingImageBottomCell.identifier, for: indexPath) as? HomeWritingImageBottomCell else { return UICollectionViewCell() }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - 4) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        2
    }
}
