//
//  HomeDetailCellType.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/06.
//

import UIKit

enum HomeDetailCellType: Int, CaseIterable {
    case main = 0
    case status
    case description
    case leader
    case member
    
    var type: UICollectionViewCell.Type {
        switch self {
        case .main: return HomeDetailMainCell.self
        case .status: return HomeDetailStatusCell.self
        case .description: return HomeDetailDescriptionCell.self
        case .leader: return HomeDetailLeaderCell.self
        case .member: return HomeDetailMemberCell.self
        }
    }
    
    static var minimumLineSpacingForSection: CGFloat {
        0
    }
    
    static var numberOfItemsInSection: Int {
        self.allCases.count
    }
    
    var height: CGFloat {
        switch self {
        case .main: return 280 + 156 + 8
        case .status: return 172 + 8
        case .description: return 92 + 8
        case .leader: return (80 + 99) + 8
        case .member: return 64 + (99 + 8) * 0 + 64
        }
    }
    
    static func configureCollectionView(_ viewController: UIViewController, _ collectionView: UICollectionView) {
        collectionView.delegate = viewController as? UICollectionViewDelegate
        collectionView.dataSource = viewController as? UICollectionViewDataSource
        
        self.allCases.forEach {
            collectionView.register(.init(nibName: $0.type.identifier, bundle: nil), forCellWithReuseIdentifier: $0.type.identifier)
        }
    }

    static func configureCellSize(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ viewModel: HomeDetailViewModel) -> CGSize {
        let cellType = HomeDetailCellType(rawValue: indexPath.row)
        var size = CGSize(width: collectionView.frame.width, height: cellType?.height ?? 0)
        
        if cellType == .member {
            size.height = 64 + (99 + 8) * CGFloat(viewModel.state.teamMembers.value.count) + 64
        }
        
        if cellType == .description {
            if let description = viewModel.state.post.value?.description {
                let descriptionHeight: CGFloat = description.size(withAttributes: nil).height
                size.height = 92 + descriptionHeight + 8
            }
        }
        
        return size
    }
    
    static func configureCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ viewModel: HomeDetailViewModel) -> UICollectionViewCell {
        let cell = UICollectionViewCell()

        switch indexPath.row {
        case 0: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailMainCell.identifier, for: indexPath) as? HomeDetailMainCell else { return cell }
            if let post = viewModel.state.post.value {
                cell.updateUI(post)
            }
            return cell
        case 1: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailStatusCell.identifier, for: indexPath) as? HomeDetailStatusCell else { return cell }
            cell.recruitingStatuses = viewModel.state.recruitingStatuses.value
            return cell
        case 2: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailDescriptionCell.identifier, for: indexPath) as? HomeDetailDescriptionCell else { return cell }
            if let post = viewModel.state.post.value {
                cell.updateUI(post.description)
            }
            return cell
        case 3: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailLeaderCell.identifier, for: indexPath) as? HomeDetailLeaderCell else { return cell }
            if let leader = viewModel.state.post.value?.leader {
                cell.leader = leader
            }
            return cell
        case 4: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailMemberCell.identifier, for: indexPath) as? HomeDetailMemberCell else { return cell }
            return cell
        default: break
        }

        return cell
    }
}
