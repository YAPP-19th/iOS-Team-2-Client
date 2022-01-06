//
//  HomeWritingMembersCountBottomCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/15.
//

import UIKit

protocol HomeWritingMembersCountBottomCellDelegate: AnyObject {
    func getRecruitingPositions(_ recruitingPositions: [RecruitingPosition])
}

final class HomeWritingMembersCountBottomCell: UICollectionViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    var recruitingPositions: [RecruitingPosition] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    weak var delegate: HomeWritingMembersCountBottomCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
}

// MARK: - Delegate
extension HomeWritingMembersCountBottomCell: HomeWritingMembersCountBottomCollectionViewCellDelegate {
    func getRecruitingPosition(_ recruitingPosition: RecruitingPosition) {
        if let index = recruitingPositions.firstIndex(of: recruitingPosition) {
            recruitingPositions[index] = recruitingPosition
        }
        delegate?.getRecruitingPositions(recruitingPositions)
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
        recruitingPositions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingMembersCountBottomCollectionViewCell.identifier, for: indexPath) as? HomeWritingMembersCountBottomCollectionViewCell else { return UICollectionViewCell() }
        cell.delegate = self
        cell.recruitingPosition = recruitingPositions[indexPath.row]
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
