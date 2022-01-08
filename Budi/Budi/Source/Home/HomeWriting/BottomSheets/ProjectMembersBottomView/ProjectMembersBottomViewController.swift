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
        configureCollectionView()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.getRecruitingPositions(recruitingPositions)
    }
}

private extension ProjectMembersBottomViewController {
    func setPublisher() {
        backgroundView.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.dismiss(animated: false, completion: nil)
            }.store(in: &cancellables)
        
        completeButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
            }.store(in: &cancellables)
    }
    
    func configureUI() {
    }
    
    func reloadCollectionViews() {
        positionCollectionView.reloadData()
        detailCollectionView.reloadData()
        memberCollectionView.reloadData()
    }
}

// MARK: - Deleagate
extension ProjectMembersBottomViewController: ProjectMembersBottomMemberCellDelegate {
    func editRecruitingPosition(_ recruitingPosition: RecruitingPosition) {
        print("recruitingPosition is \(recruitingPosition)")
        
        guard let index = recruitingPositions.firstIndex(of: recruitingPosition) else { return }
        recruitingPositions[index] = recruitingPosition
        memberCollectionView.reloadData()
    }
}

// MARK: - CollectionView
extension ProjectMembersBottomViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func configureCollectionView() {
        positionCollectionView.dataSource = self
        positionCollectionView.delegate = self
        detailCollectionView.dataSource = self
        detailCollectionView.delegate = self
        memberCollectionView.dataSource = self
        memberCollectionView.delegate = self

        positionCollectionView.register(.init(nibName: ProjectMembersBottomPositionCell.identifier, bundle: nil), forCellWithReuseIdentifier: ProjectMembersBottomPositionCell.identifier)
        detailCollectionView.register(.init(nibName: ProjectMembersBottomDetailCell.identifier, bundle: nil), forCellWithReuseIdentifier: ProjectMembersBottomDetailCell.identifier)
        memberCollectionView.register(.init(nibName: ProjectMembersBottomMemberCell.identifier, bundle: nil), forCellWithReuseIdentifier: ProjectMembersBottomMemberCell.identifier)
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
            return cell
            
        case detailCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectMembersBottomDetailCell.identifier, for: indexPath) as? ProjectMembersBottomDetailCell else { return UICollectionViewCell() }
            var detailPosition = ""
            
            if let selectedPosition = selectedPosition {
                switch selectedPosition {
                case .developer: detailPosition = developerPositions[indexPath.row]
                case .designer: detailPosition = designerPositions[indexPath.row]
                case .productManager: detailPosition = productManagerPositions[indexPath.row]
                }
            }
            let isSelected = recruitingPositions.map { $0.positionName }.contains(detailPosition)
            
            cell.configureUI(detailPosition)
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
            self.selectedPosition = Position(rawValue: indexPath.row+1)
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
            print("recruitingPositions is \(recruitingPositions)")
            self.detailCollectionView.reloadData()
            self.memberCollectionView.reloadData()

        case memberCollectionView: break
        default: break
        }
    }
    
    // MARK: - Size, Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: 100, height: 100)

        switch collectionView {
        case positionCollectionView:
            size = CGSize(width: 74, height: collectionView.bounds.height)
        case detailCollectionView:
            size = CGSize(width: (collectionView.bounds.width-8*3)/4, height: 32)
        case memberCollectionView:
            size = CGSize(width: collectionView.bounds.width, height: 48)
        default: break
        }
        
        return size
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
