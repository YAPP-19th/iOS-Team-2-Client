//
//  HomeWritingMembersBottomViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/13.
//

import UIKit
import Combine
import CombineCocoa

protocol HomeWritingMembersBottomViewControllerDelegate: AnyObject {
    func getRecruitingPositions(_ recruitingPositions: [RecruitingPosition])
}

final class HomeWritingMembersBottomViewController: UIViewController {
    
    @IBOutlet private weak var backgroundButton: UIButton!
    
    @IBOutlet private weak var completeView: UIView!
    @IBOutlet private weak var completeButton: UIButton!
    
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var bottomViewTopConstraint: NSLayoutConstraint!
    
    private var isBottomViewShown: Bool = false
    private var selectedPosition: Position?
    private var selectedParts: [String] = [] {
        didSet {
            if !selectedParts.isEmpty {
                completeButton.isEnabled = true
                completeButton.backgroundColor = .primary
            } else {
                completeButton.isEnabled = false
                completeButton.backgroundColor = .textDisabled
            }
        }
    }
    private var recruitingPositions: [RecruitingPosition] = []
    
    weak var delegate: HomeWritingMembersBottomViewControllerDelegate?
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

private extension HomeWritingMembersBottomViewController {
    func setPublisher() {
        completeButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.selectedParts.forEach {
                    let position = RecruitingPosition(position: $0, recruitingNumber: 1)
                    self.recruitingPositions.append(position)
                }
                self.delegate?.getRecruitingPositions(self.recruitingPositions)
                self.hideBottomView()
            }.store(in: &cancellables)
        
        backgroundButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.hideBottomView()
            }.store(in: &cancellables)
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

// MARK: - Delegate
extension HomeWritingMembersBottomViewController: HomeWritingMembersPartBottomCellDelegate {
    func getPosition(_ position: Position) {
        print("position is \(position)")
        selectedPosition = position
        collectionView.reloadData()
    }
}

extension HomeWritingMembersBottomViewController: HomeWritingMembersDetailPartBottomCellDelegate {
    func getSelectedParts(_ parts: [String]) {
        print("selectedParts is \(parts)")
        selectedParts = parts
        collectionView.reloadData()
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
        Position.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingMembersPartBottomCell.identifier, for: indexPath) as? HomeWritingMembersPartBottomCell else { return UICollectionViewCell() }
            cell.delegate = self
            return cell
            
        case 1: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingMembersDetailPartBottomCell.identifier, for: indexPath) as? HomeWritingMembersDetailPartBottomCell else { return UICollectionViewCell() }
            cell.delegate = self
            switch selectedPosition {
            case .developer: cell.partStrings = viewModel.state.developerPositions.value
            case .designer: cell.partStrings = viewModel.state.designerPositions.value
            case .productManager: cell.partStrings = viewModel.state.productManagerPositions.value
            default: break
            }
            return cell
            
        case 2: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingMembersCountBottomCell.identifier, for: indexPath) as? HomeWritingMembersCountBottomCell else { return UICollectionViewCell() }
            cell.recruitingPositions = recruitingPositions
            cell.selectedParts = selectedParts
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
