//
//  HomeWritingPartBottomViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/13.
//

import UIKit
import Combine
import CombineCocoa

protocol HomeWritingPartBottomViewControllerDelegate: AnyObject {
    func getPart(_ part: String)
}

final class HomeWritingPartBottomViewController: UIViewController {
    
    @IBOutlet private weak var backgroundButton: UIButton!
    @IBOutlet private weak var bottomView: UIView!
    
    @IBOutlet private weak var completeView: UIView!
    @IBOutlet private weak var completeButton: UIButton!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var bottomViewTopConstraint: NSLayoutConstraint!
    
    private var isBottomViewShown: Bool = false
    private var selectedPart: String?
    private var isPartSelected: Bool = false {
        didSet {
            completeButton.isEnabled = true
            completeButton.backgroundColor = .primary
        }
    }
    
    weak var delegate: HomeWritingPartBottomViewControllerDelegate?
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

private extension HomeWritingPartBottomViewController {
    func bindViewModel() {
    }
    
    func setPublisher() {
        completeButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                if let part = self.selectedPart {
                    self.delegate?.getPart(part)
                }
                self.hideBottomView()
            }.store(in: &cancellables)
        
        backgroundButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.hideBottomView()
            }.store(in: &cancellables)
    }
}

private extension HomeWritingPartBottomViewController {
    func showBottomView() {
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear) { [weak self] in
            guard let self = self else { return }
            self.bottomViewTopConstraint.constant -= self.bottomView.bounds.height - 95
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
            self.bottomViewTopConstraint.constant += self.bottomView.bounds.height - 95
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
extension HomeWritingPartBottomViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(.init(nibName: HomeWritingPartBottomCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeWritingPartBottomCell.identifier)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.state.parts.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingPartBottomCell.identifier, for: indexPath) as? HomeWritingPartBottomCell else { return UICollectionViewCell() }
        cell.configureUI(viewModel.state.parts.value[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isPartSelected = true
        guard let cell = collectionView.cellForItem(at: indexPath) as? HomeWritingPartBottomCell else { return }
        cell.configureSelectedUI()
        selectedPart = viewModel.state.parts.value[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? HomeWritingPartBottomCell else { return }
        cell.configureDeselectedUI()
    }
}
