//
//  HomeDetailStatusCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/02.
//

import UIKit

class HomeDetailStatusCell: UICollectionViewCell {

    @IBOutlet weak var firstJobGroupLabel: UILabel!
    @IBOutlet weak var firstStateLabel: UILabel!
    @IBOutlet weak var secondJobGroupLabel: UILabel!
    @IBOutlet weak var secondStateLabel: UILabel!
    @IBOutlet weak var thirdJobGroupLabel: UILabel!
    @IBOutlet weak var thirdStateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateUI(_ recruitingStatusResponses: [RecruitingStatusResponse]) {
        firstJobGroupLabel.text = recruitingStatusResponses[0].positionName
        firstStateLabel.text = recruitingStatusResponses[0].status
        secondJobGroupLabel.text = recruitingStatusResponses[1].positionName
        secondStateLabel.text = recruitingStatusResponses[1].status
        thirdJobGroupLabel.text = recruitingStatusResponses[2].positionName
        thirdStateLabel.text = recruitingStatusResponses[2].status
    }
}
