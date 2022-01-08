//
//  ProjectMembersBottomViewController.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/08.
//

import UIKit
import Combine

protocol ProjectMembersBottomViewControllerDelegate: AnyObject {
    func getRecruitingPositions(_ recruitingPositions: [RecruitingPosition])
}

final class ProjectMembersBottomViewController: UIViewController {

    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var completeButtonContainerView: UIView!
    @IBOutlet private weak var completeButton: UIButton!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var positionCollectionView: UICollectionView!
    @IBOutlet private weak var detailCollectionView: UICollectionView!
    @IBOutlet private weak var memberCollectionView: UICollectionView!
    
    @IBOutlet weak var bottomViewTopConstraint: NSLayoutConstraint!

    @IBOutlet private weak var detailCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var memberCollectionViewHeightConstraint: NSLayoutConstraint!
    
    private var cancellables = Set<AnyCancellable>()
    
    private let developerPositions: [String]
    private let designerPositions: [String]
    private let productManagerPositions: [String]
    
    private var selectedPosition: Position?
    private var recruitingPositions: [RecruitingPosition] = []
    
    weak var delegate: ProjectMembersBottomViewControllerDelegate?

    init(nibName: String?, bundle: Bundle?, developerPositions: [String], designerPositions: [String], productManagerPositions: [String]) {
        self.developerPositions = developerPositions
        self.designerPositions = designerPositions
        self.productManagerPositions = productManagerPositions
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        completeButtonContainerView.layer.addBorderTop()
        bottomView.addCornerRadius(corners: [.topLeft, .topRight], radius: 20)
        
        setPublisher()
        setCollectionView()
        configureCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // MARK: - showBottomView
        showBottomView(constant: 540)
    }
}

private extension ProjectMembersBottomViewController {
    func setPublisher() {
        backgroundView.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.getRecruitingPositions(self.recruitingPositions)
                self.hideBottomView()
            }.store(in: &cancellables)
        
        completeButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.getRecruitingPositions(self.recruitingPositions)
                self.hideBottomView()
            }.store(in: &cancellables)
    }

    func configureCompleteButton(_ isEnabled: Bool) {
        completeButton.isEnabled = isEnabled
        completeButton.backgroundColor = isEnabled ? .primary : .textDisabled
    }
    
    private func trimDetailPositionName(_ detailPosition: String, _ part: String) -> String {
        var trimmedName = detailPosition
        trimmedName = trimmedName.replacingOccurrences(of: "개발", with: "").trimmingCharacters(in: .whitespaces)
        trimmedName = trimmedName.trimmingCharacters(in: .whitespaces)
        return trimmedName
    }

    // MARK: - Animation
    func showBottomView(constant: CGFloat) {
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear) { [weak self] in
            guard let self = self else { return }
            self.bottomViewTopConstraint.constant = -constant
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }

    func hideBottomView() {
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear) { [weak self] in
            guard let self = self else { return }
            self.bottomViewTopConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        animator.addCompletion { [weak self] _ in
            self?.dismiss(animated: false, completion: nil)
        }
        animator.startAnimation()
    }
}

// MARK: - Deleagate
extension ProjectMembersBottomViewController: ProjectMembersBottomMemberCellDelegate {
    func editRecruitingPosition(_ recruitingPosition: RecruitingPosition) {
        guard let index = recruitingPositions.firstIndex(of: recruitingPosition) else { return }
        recruitingPositions[index] = recruitingPosition
        memberCollectionView.reloadData()
    }
}

// MARK: - CollectionView
extension ProjectMembersBottomViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func setCollectionView() {
        positionCollectionView.dataSource = self
        positionCollectionView.delegate = self
        detailCollectionView.dataSource = self
        detailCollectionView.delegate = self
        memberCollectionView.dataSource = self
        memberCollectionView.delegate = self
        
        detailCollectionView.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
        if let flowLayout = detailCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }

        positionCollectionView.register(.init(nibName: ProjectMembersBottomPositionCell.identifier, bundle: nil), forCellWithReuseIdentifier: ProjectMembersBottomPositionCell.identifier)
        detailCollectionView.register(.init(nibName: ProjectMembersBottomDetailCell.identifier, bundle: nil), forCellWithReuseIdentifier: ProjectMembersBottomDetailCell.identifier)
        memberCollectionView.register(.init(nibName: ProjectMembersBottomMemberCell.identifier, bundle: nil), forCellWithReuseIdentifier: ProjectMembersBottomMemberCell.identifier)
    }
    
    func configureCollectionView() {
        guard !recruitingPositions.isEmpty else { return }
        let count = recruitingPositions.count < 4 ? recruitingPositions.count : 3
        memberCollectionViewHeightConstraint.constant = CGFloat(48*count)
        // MARK: - showBottomView(constant: 350+CGFloat(48*count)+40)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case positionCollectionView: return 3
        case detailCollectionView:
            guard selectedPosition != nil else { return 0 }
            switch selectedPosition {
            case .developer: return developerPositions.count
            case .designer: return designerPositions.count
            case .productManager: return productManagerPositions.count
            default: return 0
            }
        case memberCollectionView: return recruitingPositions.count
        default: break
        }
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case positionCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectMembersBottomPositionCell.identifier, for: indexPath) as? ProjectMembersBottomPositionCell else { return UICollectionViewCell() }
            let position = Position.allCases[indexPath.row]
            if let selectedPosition = selectedPosition {
                cell.configureSelectedUI(position: position, selectedPosition: selectedPosition)
            } else {
                cell.configureUI(position: position)
            }
            // MARK: - showBottomView
//            showBottomView(constant: 350)
            return cell
            
        case detailCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectMembersBottomDetailCell.identifier, for: indexPath) as? ProjectMembersBottomDetailCell else { return UICollectionViewCell() }
            var detailPosition = ""
            var trimmedPosition = ""
            
            if let selectedPosition = selectedPosition {
                switch selectedPosition {
                case .developer:
                    detailPosition = developerPositions[indexPath.row]
                    trimmedPosition = trimDetailPositionName(detailPosition, "개발")
                case .designer:
                    detailPosition = designerPositions[indexPath.row]
                    trimmedPosition = trimDetailPositionName(detailPosition, "디자인")
                case .productManager:
                    detailPosition = productManagerPositions[indexPath.row]
                    trimmedPosition = trimDetailPositionName(detailPosition, "디자인")
                }
            }
            let isSelected = recruitingPositions.map { $0.positionName }.contains(detailPosition)
            
            cell.configureUI(trimmedPosition)
            cell.configureSelectedUI(isSelected)
            return cell
            
        case memberCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectMembersBottomMemberCell.identifier, for: indexPath) as? ProjectMembersBottomMemberCell else { return UICollectionViewCell() }
            cell.delegate = self
            cell.configureUI(recruitingPositions[indexPath.row])
            return cell
        default: return UICollectionViewCell()
        }
    }

    // MARK: - Select
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case positionCollectionView:
            guard let newSelectedPosition = Position(rawValue: indexPath.row+1),
                    newSelectedPosition != self.selectedPosition else { return }
            self.selectedPosition = newSelectedPosition
            self.positionCollectionView.reloadData()
            self.detailCollectionView.reloadData()
            
        case detailCollectionView:
            guard let selectedPosition = selectedPosition else { return }
            var recruitingPosition: RecruitingPosition?

            switch selectedPosition {
            case .developer:
                recruitingPosition = RecruitingPosition(positionName: developerPositions[indexPath.row], recruitingNumber: 1)
            case .designer:
                recruitingPosition = RecruitingPosition(positionName: designerPositions[indexPath.row], recruitingNumber: 1)
            case .productManager:
                recruitingPosition = RecruitingPosition(positionName: productManagerPositions[indexPath.row], recruitingNumber: 1)
            }
            guard let recruitingPosition = recruitingPosition else { return }
            
            if recruitingPositions.contains(recruitingPosition) {
                recruitingPositions = recruitingPositions.filter { $0 != recruitingPosition }
            } else {
                recruitingPositions.append(recruitingPosition)
            }
            self.detailCollectionView.reloadData()
            self.memberCollectionView.reloadData()
            self.configureCompleteButton(!recruitingPositions.isEmpty)
            self.configureCollectionView()
            
        case memberCollectionView: break
        default: break
        }
    }
    
    // MARK: - Size, Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case positionCollectionView: return CGSize(width: 74, height: collectionView.bounds.height)
        case detailCollectionView:
            var detailPosition = ""
            switch selectedPosition {
            case .developer: detailPosition = trimDetailPositionName(developerPositions[indexPath.row], "개발")
            case .designer: detailPosition = trimDetailPositionName(designerPositions[indexPath.row], "디자인")
            case .productManager: detailPosition = trimDetailPositionName(productManagerPositions[indexPath.row], "기획")
            default: break
            }
            return calculateDetailCellSize(for: indexPath, detailPosition)
        case memberCollectionView: return CGSize(width: collectionView.bounds.width, height: 48)
        default: break
        }
        return .zero
    }
    
    private func calculateDetailCellSize(for indexPath: IndexPath, _ detailPosition: String) -> CGSize {
        guard let dummyCell = Bundle.main.loadNibNamed(ProjectMembersBottomDetailCell.identifier, owner: self, options: nil)?.first as? ProjectMembersBottomDetailCell else { return .zero }
        
        dummyCell.configureUI(detailPosition)
        dummyCell.setNeedsLayout()
        dummyCell.layoutIfNeeded()
        
        let estimatedSize = dummyCell.systemLayoutSizeFitting(CGSize(width: 50, height: 32))
        return estimatedSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case positionCollectionView: return (collectionView.bounds.width - 74*3)/2
        case detailCollectionView: return 8
        case memberCollectionView: return 0
        default: return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case positionCollectionView: return 0
        case detailCollectionView: return 8
        case memberCollectionView: return 0
        default: return 0
        }
    }
}

// https://daddycoding.com/2020/04/29/left-align-collectionview-cell/
class CollectionViewLeftAlignFlowLayout: UICollectionViewFlowLayout {
    let cellSpacing: CGFloat = 10
 
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = 10.0
        self.sectionInset = UIEdgeInsets(top: 12.0, left: 16.0, bottom: 0.0, right: 16.0)
        let attributes = super.layoutAttributesForElements(in: rect)
 
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + cellSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}
