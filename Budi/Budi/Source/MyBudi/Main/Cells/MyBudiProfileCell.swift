//
//  MyBudiProfileCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/21.
//

import UIKit
import Combine
import CombineCocoa

final class MyBudiProfileCell: UICollectionViewCell {
    var cancellables = Set<AnyCancellable>()
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var userNickNameLabel: UILabel!
    @IBOutlet weak var userPositionLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    
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

}
