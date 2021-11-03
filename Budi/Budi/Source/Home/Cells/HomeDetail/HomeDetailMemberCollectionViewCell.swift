//
//  HomeDetailMemberCollectionViewCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/02.
//

import UIKit

class HomeDetailMemberCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
}

private extension HomeDetailMemberCollectionViewCell {
    func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(.init(nibName: HomeDetailPersonCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailPersonCollectionViewCell.identifier)
    }
}

extension HomeDetailMemberCollectionViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailPersonCollectionViewCell.identifier, for: indexPath) as UICollectionViewCell
        return cell
    }
}

extension HomeDetailMemberCollectionViewCell: UICollectionViewDelegate {

}

extension HomeDetailMemberCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}
