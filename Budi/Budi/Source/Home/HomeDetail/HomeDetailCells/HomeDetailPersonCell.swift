//
//  HomeDetailPersonCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/03.
//

import UIKit

final class HomeDetailPersonCell: UICollectionViewCell {
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var jobLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var characterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(_ leader: Leader) {
        nameLabel.text = leader.nickName.isEmpty ? "Unknown" : leader.nickName
        jobLabel.text = leader.position.position.isEmpty ? "기타" : leader.position.position
        addressLabel.text = leader.address.isEmpty ? "서울시 강남구" : leader.address

        characterImageView.image = Position(rawValue: leader.position.colorCode)?.iconImage
        if let url = URL(string: leader.profileImageUrl) {
            profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "person.circle.fill"))
        }
    }
    
    func updateUI(_ teamMember: TeamMember) {
        nameLabel.text = teamMember.nickName.isEmpty ? "Unknown" : teamMember.nickName
        jobLabel.text = teamMember.position.position.isEmpty ? "기타" : teamMember.position.position
        addressLabel.text = teamMember.address.isEmpty ? "서울시 강남구" : teamMember.address

        characterImageView.image = Position(rawValue: teamMember.position.colorCode)?.iconImage
        if let url = URL(string: teamMember.profileImageUrl) {
            profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "person.circle.fill"))
        }
    }
}
