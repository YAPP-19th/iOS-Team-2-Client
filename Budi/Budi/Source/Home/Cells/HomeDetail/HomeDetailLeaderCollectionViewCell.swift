//
//  HomeDetailLeaderCollectionViewCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/02.
//

import UIKit

class HomeDetailLeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
}

private extension HomeDetailLeaderCollectionViewCell {
    func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(.init(nibName: HomeDetailPersonCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailPersonCollectionViewCell.identifier)
    }
}

extension HomeDetailLeaderCollectionViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailPersonCollectionViewCell.identifier, for: indexPath) as UICollectionViewCell
        return cell
    }
}

extension HomeDetailLeaderCollectionViewCell: UICollectionViewDelegate {

}

extension HomeDetailLeaderCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 80)
    }
}
