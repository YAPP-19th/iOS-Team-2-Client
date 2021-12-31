//
//  HomeDetailStatusUnitCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/06.
//

import UIKit

final class HomeDetailStatusUnitCell: UICollectionViewCell {
    
    @IBOutlet private weak var characterImageView: UIImageView!
    @IBOutlet private weak var positionNameLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(_ recruitingStatus: RecruitingStatus) {
        positionNameLabel.text = recruitingStatus.positions.position
        countLabel.text = recruitingStatus.approvedStatus
        
        switch recruitingStatus.positions.colorCode {
        case 1: characterImageView.image = UIImage(named: "Developer")
        case 2: characterImageView.image = UIImage(named: "Planner")
        case 3: characterImageView.image = UIImage(named: "Designer")
        default: break
        }
    }
}
