//
//  HomeDetailStatusUnitCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/06.
//

import UIKit

final class HomeDetailStatusUnitCell: UICollectionViewCell {
    
    @IBOutlet private weak var positionNameLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(_ recruitingStatus: RecruitingStatus) {
        positionNameLabel.text = recruitingStatus.positionName
        countLabel.text = "\(recruitingStatus.status)/\(recruitingStatus.status)"
    }
}
