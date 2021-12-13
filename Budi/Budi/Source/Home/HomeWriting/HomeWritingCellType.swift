//
//  HomeWritingCellType.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/13.
//

import UIKit

enum HomeWritingCellType: Int, CaseIterable {
    case image = 0
    case name
    case part
    case duration
    case online
    case area
    case members
    case description
    
    var height: CGFloat {
        switch self {
        case .image: return 280
        case .name: return 109
        case .part: return 117
        case .duration: return 109
        case .online: return 117
        case .area: return 117
        case .members: return 117
        case .description: return 387 + 64
        }
    }
    
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

    static func getCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()

        switch indexPath.row {
        case 0: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingImageCell.identifier, for: indexPath) as? HomeWritingImageCell else { return cell }
            return cell
        case 1: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingNameCell.identifier, for: indexPath) as? HomeWritingNameCell else { return cell }
            return cell
        case 2: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingPartCell.identifier, for: indexPath) as? HomeWritingPartCell else { return cell }
            return cell
        case 3: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingDurationCell.identifier, for: indexPath) as? HomeWritingDurationCell else { return cell }
            return cell
        case 4: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingOnlineCell.identifier, for: indexPath) as? HomeWritingOnlineCell else { return cell }
            return cell
        case 5: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingAreaCell.identifier, for: indexPath) as? HomeWritingAreaCell else { return cell }
            return cell
        case 6: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingMembersCell.identifier, for: indexPath) as? HomeWritingMembersCell else { return cell }
            return cell
        case 7: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingDescriptionCell.identifier, for: indexPath) as? HomeWritingDescriptionCell else { return cell }
            return cell
        default: break
        }
        
        return cell
    }
}
