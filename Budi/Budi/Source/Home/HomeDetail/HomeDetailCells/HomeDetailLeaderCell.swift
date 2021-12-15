//
//  HomeDetailLeaderCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/02.
//

import UIKit

final class HomeDetailLeaderCell: UICollectionViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!
    var leader: Leader = Leader(leaderId: 0, nickName: "", profileImageUrl: "", address: "") {
        didSet {
            collectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
}

private extension HomeDetailLeaderCell {
}

extension HomeDetailLeaderCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(.init(nibName: HomeDetailPersonCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailPersonCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailPersonCell.identifier, for: indexPath) as? HomeDetailPersonCell else { return UICollectionViewCell() }
        cell.updateUI(leader.nickName, leader.profileImageUrl, leader.address)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 80)
    }
}
