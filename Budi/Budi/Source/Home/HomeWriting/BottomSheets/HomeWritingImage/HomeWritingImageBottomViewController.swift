//
//  HomeWritingImageBottomViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/13.
//

import UIKit
import Combine
import CombineCocoa

protocol HomeWritingImageBottomViewControllerDelegate: AnyObject {
    func getImageUrlString(_ urlString: String)
}

final class HomeWritingImageBottomViewController: UIViewController {
    
    @IBOutlet private weak var backgroundButton: UIButton!
    
    @IBOutlet private weak var completeView: UIView!
    @IBOutlet private weak var completeButton: UIButton!
    
    @IBOutlet private weak var bottomScrollView: UIScrollView!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var myAlbumButton: UIButton!
    @IBOutlet private weak var bottomViewTopConstraint: NSLayoutConstraint!

    private var isBottomViewShown: Bool = false
    
    private var selectedIndex: Int? {
        didSet {
            completeButton.isEnabled = true
            completeButton.backgroundColor = .primary
        }
    }
    
    weak var delegate: HomeWritingImageBottomViewControllerDelegate?
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
        setPublisher()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showBottomView()
    }
}

private extension HomeWritingImageBottomViewController {
    func setPublisher() {
        backgroundButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.hideBottomView()
            }.store(in: &cancellables)
        
        myAlbumButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                print("내 앨범에서 추가")
            }.store(in: &cancellables)
        
        completeButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self, let selectedIndex = self.selectedIndex else { return }
                let urlString = self.viewModel.state.defaultImageUrls.value[selectedIndex]
                self.delegate?.getImageUrlString(urlString)
                self.hideBottomView()
            }.store(in: &cancellables)
    }
}

private extension HomeWritingImageBottomViewController {
    func showBottomView() {
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear) { [weak self] in
            guard let self = self else { return }
            self.bottomViewTopConstraint.constant -= self.bottomScrollView.bounds.height - 95
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
            self.bottomViewTopConstraint.constant += self.bottomScrollView.bounds.height - 95
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
        cell.configureUI(viewModel.state.defaultImageUrls.value[indexPath.row])
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row

        guard let cell = collectionView.cellForItem(at: indexPath) as? HomeWritingImageBottomCell else { return }
        cell.addBorder()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? HomeWritingImageBottomCell else { return }
        cell.removeBorder()
    }
}
