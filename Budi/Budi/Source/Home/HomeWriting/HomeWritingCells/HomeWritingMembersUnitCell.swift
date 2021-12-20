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
    
    func configureUI(_ position: RecruitingPosition) {
        let positionName = position.positionName
        positionLabel.text = positionName
        countLabel.text = String(position.recruitingNumber)
        
        var characterImage: UIImage?
        if positionName.contains("개발") {
            characterImage = Position.developer.characterImage
        } else if positionName.contains("디자인") {
            characterImage = Position.designer.characterImage
        } else if positionName.contains("기획") {
            characterImage = Position.productManager.characterImage
        }
        
        if let characterImage = characterImage {
            imageView.image = characterImage
        }
    }
}
