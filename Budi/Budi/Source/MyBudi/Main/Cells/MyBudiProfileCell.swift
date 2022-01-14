//
//  MyBudiProfileCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/21.
//

import UIKit
import Combine
import CombineCocoa
import Kingfisher

final class MyBudiProfileCell: UICollectionViewCell {
    var cancellables = Set<AnyCancellable>()

    @IBOutlet weak var userCharacterImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var userNickNameLabel: UILabel!
    @IBOutlet weak var userPositionLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setUserData(nickName: String, position: String, description: String) {
        userNickNameLabel.text = nickName
        userPositionLabel.text = position
        userDescriptionLabel.text = description
    }

    func configureUserImage(url: String, basePosition: Int) {
        guard let url = URL(string: url) else { return }
        userImageView.contentMode = .scaleAspectFill
        userImageView.kf.setImage(with: url)

        switch basePosition {
        case 1:
            userCharacterImageView.image = UIImage(named: "developer")
        case 2:
            userCharacterImageView.image = UIImage(named: "designer")
        case 3:
            userCharacterImageView.image = UIImage(named: "planner")
        default:
            break
        }
    }

}
