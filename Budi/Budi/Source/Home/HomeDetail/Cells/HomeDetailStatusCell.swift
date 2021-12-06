//
//  HomeDetailStatusCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/02.
//

import UIKit

final class HomeDetailStatusCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var recruitingStatuses: [RecruitingStatus] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
}

private extension HomeDetailStatusCell {
    func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(.init(nibName: HomeDetailStatusUnitCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailStatusUnitCell.identifier)
    }
}

extension HomeDetailStatusCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recruitingStatuses.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailStatusUnitCell.identifier, for: indexPath) as? HomeDetailStatusUnitCell else { return UICollectionViewCell() }
        cell.updateUI(recruitingStatuses[indexPath.row])
        return cell
    }
}

extension HomeDetailStatusCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width / CGFloat(recruitingStatuses.count), height: 76)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
