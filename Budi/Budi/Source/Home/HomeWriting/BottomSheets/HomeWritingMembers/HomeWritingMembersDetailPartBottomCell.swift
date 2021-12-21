//
//  HomeWritingMembersDetailPartBottomCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/15.
//

import UIKit

final class HomeWritingMembersDetailPartBottomCell: UICollectionViewCell {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var partStrings: [String] = ["iOS", "하이브리드", "AOS", "Web", "블록체인", "AI", "웹서버", "기타"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
}

// MARK: - CollectionView
extension HomeWritingMembersDetailPartBottomCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(.init(nibName: HomeWritingMembersDetailPartBottomCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeWritingMembersDetailPartBottomCollectionViewCell.identifier)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        partStrings.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingMembersDetailPartBottomCollectionViewCell.identifier, for: indexPath) as? HomeWritingMembersDetailPartBottomCollectionViewCell else { return UICollectionViewCell() }
        cell.configureUI(partStrings[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let partStringWidth: CGFloat = partStrings[indexPath.row].size(withAttributes: nil).width
        return CGSize(width: partStringWidth + 40, height: 32)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}
