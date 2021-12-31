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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(imageUrl: String, name: String, job: String, address: String) {
        nameLabel.text = name
        addressLabel.text = address
        jobLabel.text = job
        if let url = URL(string: imageUrl) {
            profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "person.circle.fill"))
        }
    }
}
