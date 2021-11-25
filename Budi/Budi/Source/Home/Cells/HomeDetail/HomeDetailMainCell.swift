//
//  HomeDetailMainCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/02.
//

import UIKit
import Kingfisher

class HomeDetailMainCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateUI(_ post: Post) {
        categoryLabel.text = post.category
        titleLabel.text = post.title
        dateLabel.text = post.startDate.convertTimePassedString()
        regionLabel.text = post.region
        if let url = URL(string: post.imageUrls.first ?? "") {
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "defaultBackground"))
        }
    }
}
