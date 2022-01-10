//
//  HomeWritingMembersCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/02.
//

import UIKit
import Combine

final class HomeWritingMembersCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addButton: UIButton!
    
    var cancellables = Set<AnyCancellable>()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }
    
    var recruitingPositions: [RecruitingPosition] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
}

// MARK: - CollectionView
extension HomeWritingMembersCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(.init(nibName: HomeWritingMembersUnitCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeWritingMembersUnitCell.identifier)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recruitingPositions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingMembersUnitCell.identifier, for: indexPath) as? HomeWritingMembersUnitCell else { return UICollectionViewCell() }
        // MARK: - colorCode 받아 적용
        let position = recruitingPositions[indexPath.row]
        let positionName = position.positionName

        var colorCode = Position.productManager.rawValue
        if positionName.contains("개발") {
            colorCode = Position.developer.rawValue
        } else if positionName.contains("디자인") {
            colorCode = Position.designer.rawValue
        } else if positionName.contains("기획") {
            colorCode = Position.productManager.rawValue
        }
                    
        cell.configureUI(position: position, colorCode: colorCode)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 48)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}
