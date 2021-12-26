//
//  HomeWritingMembersCountBottomCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/15.
//

import UIKit

final class HomeWritingMembersCountBottomCell: UICollectionViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    var selectedParts: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var recruitingPositions: [RecruitingPosition] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
}

// MARK: - CollectionView
extension HomeWritingMembersCountBottomCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(.init(nibName: HomeWritingMembersCountBottomCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeWritingMembersCountBottomCollectionViewCell.identifier)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        selectedParts.count
//        recruitingPositions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingMembersCountBottomCollectionViewCell.identifier, for: indexPath) as? HomeWritingMembersCountBottomCollectionViewCell else { return UICollectionViewCell() }
//        cell.recruitingPosition = recruitingPositions[indexPath.row]
        cell.configureUI(selectedParts[indexPath.row])
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
}
