//
//  HomeDetailBottomViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit
import Combine
import CombineCocoa

protocol RecruitingStatusBottomViewControllerDelegate: AnyObject {
    func getSelectedRecruitingStatus(_ selectedRecruitingStatus: RecruitingStatus)
}

final class RecruitingStatusBottomViewController: UIViewController {

    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var bottomViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var submitView: UIView!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var heartButton: UIButton!
    @IBOutlet private weak var heartCountLabel: UILabel!
    
    @IBAction private func backgroundButtonTapped(_ sender: Any) {
        hideBottomView()
    }
    
    private var isBottomViewShown: Bool = false
    private var isHeartButtonChecked: Bool = false
    private var selectedRecruitingStatus: RecruitingStatus? = nil {
        didSet {
            DispatchQueue.main.async {
                if self.selectedRecruitingStatus != nil {
                    self.submitButton.isEnabled = true
                    self.submitButton.backgroundColor = .primary
                } else {
                    self.submitButton.isEnabled = false
                    self.submitButton.backgroundColor = .textDisabled
                }
            }
        }
    }
    
    weak var delegate: RecruitingStatusBottomViewControllerDelegate?
    weak var coordinator: HomeCoordinator?
    private let viewModel: HomeDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(nibName: String?, bundle: Bundle?, viewModel: HomeDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitView.layer.addBorderTop()
        configureCollectionView()
        bindViewModel()
        setPublisher()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomView()
    }
}

private extension RecruitingStatusBottomViewController {
    func bindViewModel() {
        viewModel.state.post
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.configureHeartButton()
            }).store(in: &cancellables)
    }
    
    func setPublisher() {
        submitButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self, let selectedRecruitingStatus = self.selectedRecruitingStatus else { return }
                self.delegate?.getSelectedRecruitingStatus(selectedRecruitingStatus)
            }.store(in: &cancellables)

        heartButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.requestLikePost(.testAccessToken) { response in
                    switch response {
                    case .success:
                        guard let isLiked = self.viewModel.state.post.value?.isLiked else { return }
                        self.heartButton.setImage(UIImage(systemName: isLiked ? "heart.fill" : "heart"), for: .normal)
                        self.heartButton.tintColor = isLiked ? UIColor.primary : UIColor.textDisabled
                    case .failure(let error): print(error.localizedDescription)
                    }
                }
            }.store(in: &cancellables)
        
        closeButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear) { [weak self] in
                    guard let self = self else { return }
                    self.view.alpha = 0
                    self.isBottomViewShown ? self.hideBottomView() : self.showBottomView()
                }
                animator.addCompletion { [weak self] _ in
                    self?.dismiss(animated: true)
                }
                animator.startAnimation()
            }.store(in: &cancellables)
    }
    
    func showBottomView() {
        let cellHeight: CGFloat = 64
        let cellCount: Int = self.viewModel.state.recruitingStatuses.value.count
        
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear) { [weak self] in
            guard let self = self else { return }
            self.view.alpha = 1
            self.bottomViewTopConstraint.constant -= (self.bottomView.bounds.height - cellHeight * CGFloat((4 - cellCount)))
            self.view.layoutIfNeeded()
        }
        animator.addCompletion { [weak self] _ in
            self?.isBottomViewShown = true
        }
        animator.startAnimation()
    }
    
    func hideBottomView() {
        let cellHeight: CGFloat = 64
        let cellCount: Int = self.viewModel.state.recruitingStatuses.value.count
        
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear) { [weak self] in
            guard let self = self else { return }
            self.view.alpha = 0
            self.bottomViewTopConstraint.constant += (self.bottomView.bounds.height - cellHeight * CGFloat((4 - cellCount)))
            self.view.layoutIfNeeded()
        }
        animator.addCompletion { [weak self] _ in
            self?.dismiss(animated: true)
            self?.isBottomViewShown = false
            
        }
        animator.startAnimation()
    }
    
    func configureHeartButton() {
        guard let likeCount = viewModel.state.post.value?.likeCount, let isLiked = viewModel.state.post.value?.isLiked else { return }
        heartCountLabel.text = "\(likeCount)"
        heartButton.setImage(UIImage(systemName: isLiked ? "heart.fill" : "heart"), for: .normal)
        heartButton.tintColor = isLiked ? UIColor.primary : UIColor.textDisabled
    }
}

// MARK: - CollectionView
extension RecruitingStatusBottomViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(.init(nibName: RecruitingStatusBottomCell.identifier, bundle: nil), forCellWithReuseIdentifier: RecruitingStatusBottomCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.state.recruitingStatuses.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecruitingStatusBottomCell.identifier, for: indexPath) as? RecruitingStatusBottomCell else { return UICollectionViewCell() }
        cell.recruitingStatus = viewModel.state.recruitingStatuses.value[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 56)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RecruitingStatusBottomCell else { return }
        let recruitingStatus = viewModel.state.recruitingStatuses.value[indexPath.row]
        selectedRecruitingStatus = recruitingStatus
        cell.isChecked = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RecruitingStatusBottomCell else { return }
        cell.isChecked = false
    }
}
