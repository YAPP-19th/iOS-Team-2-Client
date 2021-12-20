//
//  HomeWritingCellType.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/13.
//

import UIKit
import Combine
import CombineCocoa

enum HomeWritingCellType: Int, CaseIterable {
    case image = 0
    case name
    case part
    case duration
    case online
    case area
    case members
    case description
    
    var type: UICollectionViewCell.Type {
        switch self {
        case .image: return HomeWritingImageCell.self
        case .name: return HomeWritingNameCell.self
        case .part: return HomeWritingPartCell.self
        case .duration: return HomeWritingDurationCell.self
        case .online: return HomeWritingOnlineCell.self
        case .area: return HomeWritingAreaCell.self
        case .members: return HomeWritingMembersCell.self
        case .description: return HomeWritingDescriptionCell.self
        }
    }
    
    static var minimumLineSpacingForSection: CGFloat {
        4
    }
    
    static var numberOfItemsInSection: Int {
        self.allCases.count
    }
    
    var height: CGFloat {
        switch self {
        case .image: return 280
        case .name: return 109
        case .part: return 117
        case .duration: return 109
        case .online: return 117
        case .area: return 173 // 117 -> 173
        case .members: return 286
        case .description: return 387
        }
    }
    
    static func configureCollectionView(_ viewController: UIViewController, _ collectionView: UICollectionView) {
        collectionView.delegate = viewController as? UICollectionViewDelegate
        collectionView.dataSource = viewController as? UICollectionViewDataSource
        
        self.allCases.forEach {
            collectionView.register(.init(nibName: $0.type.identifier, bundle: nil), forCellWithReuseIdentifier: $0.type.identifier)
        }
        collectionView.contentInset.bottom = 95
    }
    
    static func configureCellSize(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> CGSize {
        let cellType = HomeWritingCellType(rawValue: indexPath.row)
        let size = CGSize(width: collectionView.frame.width, height: cellType?.height ?? 0)
        
        return size
    }
}
