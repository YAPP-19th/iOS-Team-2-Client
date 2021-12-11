//
//  BottomSheetViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit
import Combine
import CombineCocoa

class BottomSheetViewController: UIViewController {

    @IBOutlet weak var bottomSheetView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet private weak var bottomSheetViewTopConstraint: NSLayoutConstraint!
    private var isBottonSheetShown: Bool = false
    private var isHeartButtonChecked: Bool = false
    private var selectedRecruitingStatus: RecruitingStatus?
    
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
        configureCollectionView()
        setPublisher()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showBottomSheetView()
    }
}

private extension BottomSheetViewController {
    func setPublisher() {
        submitButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.isBottonSheetShown ? self.hideBottomSheetView() : self.showBottomSheetView()
            }.store(in: &cancellables)

        heartButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.isHeartButtonChecked.toggle()
                self.heartButton.setImage(UIImage(systemName: self.isHeartButtonChecked ? "heart.fill" : "heart"), for: .normal)
                self.heartButton.tintColor = self.isHeartButtonChecked ? UIColor.budiGreen : UIColor.budiGray
                self.view.layoutIfNeeded()
            }.store(in: &cancellables)
        
        closeButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear) { [weak self] in
                    guard let self = self else { return }
                    self.view.alpha = 0
                    self.isBottonSheetShown ? self.hideBottomSheetView() : self.showBottomSheetView()
                }
                animator.addCompletion { [weak self] _ in
                    self?.dismiss(animated: true)
                }
                animator.startAnimation()
            }.store(in: &cancellables)
    }
    
    func showBottomSheetView() {
        let cellHeight: CGFloat = 64
        let cellCount: Int = self.viewModel.state.recruitingStatuses.value.count
        
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear) { [weak self] in
            guard let self = self else { return }
            self.view.alpha = 1
            self.bottomSheetViewTopConstraint.constant -= (self.bottomSheetView.bounds.height - cellHeight * CGFloat((4 - cellCount)))
            self.view.layoutIfNeeded()
        }
        animator.addCompletion { [weak self] _ in
            self?.isBottonSheetShown = true
        }
        animator.startAnimation()
    }
    
    func hideBottomSheetView() {
        let cellHeight: CGFloat = 64
        let cellCount: Int = self.viewModel.state.recruitingStatuses.value.count
        
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear) { [weak self] in
            guard let self = self else { return }
            self.view.alpha = 0
            self.bottomSheetViewTopConstraint.constant += (self.bottomSheetView.bounds.height - cellHeight * CGFloat((4 - cellCount)))
            self.view.layoutIfNeeded()
        }
        animator.addCompletion { [weak self] _ in
            self?.dismiss(animated: true)
            self?.isBottonSheetShown = false
            
        }
        animator.startAnimation()
    }
    
    func bindViewModel() {
    }
    
    func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(.init(nibName: BottomSheetCell.identifier, bundle: nil), forCellWithReuseIdentifier: BottomSheetCell.identifier)
    }
}

extension BottomSheetViewController: BottomSheetCellDelegate {
    func selectBottomSheetCell(_ recruitingStatus: RecruitingStatus) {
        print(recruitingStatus.positionName)
        selectedRecruitingStatus = recruitingStatus
    }
}

extension BottomSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.state.recruitingStatuses.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomSheetCell.identifier, for: indexPath) as? BottomSheetCell else { return UICollectionViewCell() }
        cell.delegate = self
        cell.recruitingStatus = viewModel.state.recruitingStatuses.value[indexPath.row]
        return cell
    }
}

extension BottomSheetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 56)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}
