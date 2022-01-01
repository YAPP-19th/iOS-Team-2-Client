//
//  HomeDetailMainCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/02.
//

import UIKit
import Kingfisher

final class HomeDetailMainCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var viewCountLabel: UILabel!
    
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var regionLabel: UILabel!
    @IBOutlet private weak var onlineInfoLabel: UILabel!
    @IBOutlet private weak var onlineInfoLabelWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateUI(_ post: Post) {
        viewCountLabel.text = "\(post.viewCount)"
        categoryLabel.text = post.category
        titleLabel.text = post.title
        dateLabel.text = getDatePeriod(post.startDate, post.endDate)
        regionLabel.text = post.region
        onlineInfoLabel.text = post.onlineInfo
        if post.onlineInfo == "오프라인" {
            onlineInfoLabelWidthConstraint.constant = 68
        }
        
        if let url = URL(string: post.imageUrl) {
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "defaultBackground"))
        }
    }
    
    private func getDatePeriod(_ startDate: Date, _ endDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"

        let startDateString = formatter.string(from: startDate)
        let endDateString = formatter.string(from: startDate)
        let intervalMonth = Int(endDate.timeIntervalSince(startDate)) / 30 / 86400

        return "\(startDateString) - \(endDateString) \(intervalMonth > 0 ? "(\(intervalMonth)개월)" : "")"
    }
}
