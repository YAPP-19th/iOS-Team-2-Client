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

    func updateUI(_ member: SearchTeamMember, position: Position? = nil ) {
        if let position = position {
            postionLabel.superview?.backgroundColor = position.labelBackgroundColor
            postionLabel.textColor = position.labelTextColor
        }

        postionLabel.text = member.position.first

        postionLabel.sizeToFit()
        userNameLabel.text = member.nickName
        descriptionLabel.text = member.introduce
        locationLabel.text = "\(member.address.split(separator: " ").first ?? "" )"
        if let url = URL(string: member.imgURL ?? "") {
            profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "defaultBackground"))
        } else {
            profileImageView.image = position?.teamSearchCharacter
        }
    }
}
