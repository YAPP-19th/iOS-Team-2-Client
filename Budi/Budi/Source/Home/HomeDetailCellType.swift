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
    
    var height: CGFloat {
        switch self {
        case .main: return 280 + 156 + 8
        case .status: return 172 + 8
        case .description: return 200 + 8
        case .leader: return (80 + 99) + 8
        case .member: return 64 + (99 + 8) * 0 + 64
        }
    }
    
    var type: UICollectionViewCell.Type {
        switch self {
        case .main: return HomeDetailMainCell.self
        case .status: return HomeDetailStatusCell.self
        case .description: return HomeDetailDescriptionCell.self
        case .leader: return HomeDetailLeaderCell.self
        case .member: return HomeDetailMemberCell.self
        }
    }
}
