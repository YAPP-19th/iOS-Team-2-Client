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
        let positionName = recruitingStatus.positionName
        positionNameLabel.text = positionName
        countLabel.text = "\(recruitingStatus.status)/\(recruitingStatus.status)"
        
        if positionName.contains("개발") {
            characterImageView.image = UIImage(named: "Developer")
        } else if positionName.contains("디자인") {
            characterImageView.image = UIImage(named: "Designer")
        } else if positionName.contains("기획") {
            characterImageView.image = UIImage(named: "Planner")
        }
    }
}
