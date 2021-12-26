//
//  MyBudiCellType.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/22.
//

import UIKit

enum MyBudiMainCellType: Int, CaseIterable {
    case profile
    case level
    case project
    case help
    
    var type: UICollectionViewCell.Type {
        switch self {
        case .profile: return MyBudiProfileCell.self
        case .level: return MyBudiLevelCell.self
        case .project: return MyBudiProjectCell.self
        case .help: return MyBudiHelpCell.self
        }
    }
    
    static var minimumLineSpacingForSection: CGFloat {
        12
    }
    
    static var numberOfItemsInSection: Int {
        self.allCases.count
    }
    
    var height: CGFloat {
        switch self {
        case .profile: return 248
        case .level: return 108
        case .project: return 79
        case .help: return 198
        }
    }
    
    static func configureCollectionView(_ viewController: UIViewController, _ collectionView: UICollectionView) {
        collectionView.delegate = viewController as? UICollectionViewDelegate
        collectionView.dataSource = viewController as? UICollectionViewDataSource
        
        self.allCases.forEach {
            collectionView.register(.init(nibName: $0.type.identifier, bundle: nil), forCellWithReuseIdentifier: $0.type.identifier)
        }
    }
    
    static func configureCellSize(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> CGSize {
        let cellType = MyBudiMainCellType(rawValue: indexPath.row)
        let size = CGSize(width: collectionView.frame.width, height: cellType?.height ?? 0)
        
        return size
    }
}
