//
//  HomeWritingMembersPartBottomCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/15.
//

import UIKit

protocol HomeWritingMembersPartBottomCellDelegate: AnyObject {
    func getPosition(_ position: Position)
}

final class HomeWritingMembersPartBottomCell: UICollectionViewCell {
    
    @IBOutlet private weak var collectionView: UICollectionView!

    weak var delegate: HomeWritingMembersPartBottomCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
}

// MARK: - CollectionView
extension HomeWritingMembersPartBottomCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(.init(nibName: HomeWritingMembersPartUnitBottomCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeWritingMembersPartUnitBottomCell.identifier)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Position.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingMembersPartUnitBottomCell.identifier, for: indexPath) as? HomeWritingMembersPartUnitBottomCell else { return UICollectionViewCell() }
        cell.position = Position.allCases[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 80, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        (collectionView.bounds.width - 80*3) / 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.getPosition(Position.allCases[indexPath.row])
        guard let cell = collectionView.cellForItem(at: indexPath) as? HomeWritingMembersPartUnitBottomCell else { return }
        cell.configureSelectedUI()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? HomeWritingMembersPartUnitBottomCell else { return }
        cell.configureDeselectedUI()
    }
}
