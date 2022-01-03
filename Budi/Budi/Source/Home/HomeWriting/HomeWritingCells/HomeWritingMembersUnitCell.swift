//
//  HomeWritingMembersUnitCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/21.
//

import UIKit

class HomeWritingMembersUnitCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureUI(position: RecruitingPosition, colorCode: Int) {
        positionLabel.text = position.position
        countLabel.text = "\(position.recruitingNumber)"
        imageView.image = Position(rawValue: colorCode)?.characterImage
    }
}
