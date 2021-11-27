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
        dateLabel.text = getDatePeriod(post.startDate, post.endDate)
        regionLabel.text = post.region
        if let url = URL(string: post.imageUrls.first ?? "") {
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "defaultBackground"))
        }
    }

    func getDatePeriod(_ startDate: Date, _ endDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"

        let startDateString = formatter.string(from: startDate)
        let endDateString = formatter.string(from: startDate)
        let intervalMonth = Int(endDate.timeIntervalSince(startDate)) / 30 / 86400

        return "\(startDateString) - \(endDateString) \(intervalMonth > 0 ? "(\(intervalMonth)개월)" : "")"
    }
}
