//
//  HomeDetailLeaderCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/02.
//

import UIKit

class HomeDetailLeaderCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
}

private extension HomeDetailLeaderCell {
    func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(.init(nibName: HomeDetailPersonCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailPersonCell.identifier)
    }
}

extension HomeDetailLeaderCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailPersonCell.identifier, for: indexPath) as UICollectionViewCell
        return cell
    }
}

extension HomeDetailLeaderCell: UICollectionViewDelegate {

}

extension HomeDetailLeaderCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 80)
    }
}
