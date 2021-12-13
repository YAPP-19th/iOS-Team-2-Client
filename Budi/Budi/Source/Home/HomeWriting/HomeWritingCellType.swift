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
}

