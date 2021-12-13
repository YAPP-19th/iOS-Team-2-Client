//
//  HomeDetailPersonCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/03.
//

import UIKit

final class HomeDetailPersonCell: UICollectionViewCell {
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var jobLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var skillsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(_ name: String, imageUrl: String, _ address: String) {
        nameLabel.text = name
        addressLabel.text = address.isEmpty ? "" : " · \(address)"
        if let url = URL(string: imageUrl) {
            profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "person.circle.fill"))
        }
    }
}
