//
//  TeamSearchDetailCell.swift
//  Budi
//
//  Created by 최동규 on 2021/12/26.
//

import UIKit

final class TeamSearchDetailCell: UICollectionViewCell {

    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet weak var postionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        postionLabel.superview?.layer.cornerRadius = 25 / 2
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.background.cgColor
        layer.cornerRadius = 12
    }

}
