//
//  HomeWritingMembersDetailPartBottomCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/15.
//

import UIKit

protocol HomeWritingMembersDetailPartBottomCellDelegate: AnyObject {
    func getSelectedParts(_ parts: [String])
}

final class HomeWritingMembersDetailPartBottomCell: UICollectionViewCell {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var partStrings: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var selectedPartStrings: [String] = [] {
        didSet {
            delegate?.getSelectedParts(selectedPartStrings)
            collectionView.reloadData()
        }
    }
    
    weak var delegate: HomeWritingMembersDetailPartBottomCellDelegate?
    
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
        let partString = partStrings[indexPath.row]
        cell.configureUI(partString)
        cell.isPartSelected = selectedPartStrings.contains(partString)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let partString = partStrings[indexPath.row]
        if selectedPartStrings.contains(partString) {
            selectedPartStrings = selectedPartStrings.filter { $0 != partString }
        } else {
            selectedPartStrings.append(partString)
        }
    }
}
