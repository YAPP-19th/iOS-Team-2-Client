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
        jobLabel.text = leader.position.isEmpty ? "Unknown" : leader.position
        addressLabel.text = leader.address.isEmpty ? "Unknown" : leader.address
        
        // MARK: - 서버에 leader.position 정보에 colorCode가 추가되면 수정 및 적용
        let colorCode = 1
        characterImageView.image = Position(rawValue: colorCode)?.characterImage
        if let url = URL(string: leader.profileImageUrl) {
            profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "person.circle.fill"))
        }
    }
    
    func updateUI(_ teamMember: TeamMember) {
        nameLabel.text = teamMember.nickName.isEmpty ? "Unknown" : teamMember.nickName
        jobLabel.text = teamMember.position.position.isEmpty ? "Unknown" : teamMember.position.position
        addressLabel.text = teamMember.address.isEmpty ? "Unknown" : teamMember.address

        characterImageView.image = Position(rawValue: teamMember.position.colorCode)?.characterImage
        if let url = URL(string: teamMember.profileImageUrl) {
            profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "person.circle.fill"))
        }
    }
}
