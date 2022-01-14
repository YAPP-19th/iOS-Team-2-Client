//
//  TeamSearchProfileCell.swift
//  Budi
//
//  Created by 최동규 on 2022/01/06.
//

import UIKit
import Kingfisher

final class TeamSearchProfileCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var levelImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var positionDetailLabel: UILabel!
    @IBOutlet weak var conversationButton: UIButton!
    @IBOutlet weak var inviteButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 36
        levelImageView.layer.cornerRadius = 25 / 2
        levelImageView.contentMode = .scaleAspectFill
        // Initialization code
    }

    func updateUI(member: BudiMember) {
        imageView.image = Position(rawValue: member.basePosition)?.teamSearchCharacter
        if let url = URL(string: member.imgUrl) {
            imageView.kf.setImage(with: url, placeholder: Position(rawValue: member.basePosition)?.teamSearchCharacter )
        }
        nameLabel.text = member.nickName
        positionLabel.text = Position(rawValue: member.basePosition)?.jobStringValue
        positionDetailLabel.text = member.positions.map { "#\($0)" }.joined(separator: " ")
        configureLevelImage(member: member)
    }

    private func configureLevelImage(member: BudiMember ) {
        var levelImage: String = ""

        switch member.basePosition{
        case 1:
            levelImage += "Dev_"
        case 2:
            levelImage += "Design_"
        case 3:
            levelImage += "Plan_"
        default:
            break
        }
        let level = member.level
        switch level {
        case _ where level.contains("씨앗"):
            levelImage += "Lv1"
        case _ where level.contains("새싹"):
            levelImage += "Lv2"
        case _ where level.contains("꽃잎"):
            levelImage += "Lv3"
        case _ where level.contains("열매"):
            levelImage += "Lv4"
        default:
            levelImage += "Lv4"
        }

        levelImageView.image = UIImage(named: levelImage)
    }
}
