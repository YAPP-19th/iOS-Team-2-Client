//
//  NotificationListCell.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/18.
//

import UIKit

final class NotificationListCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureUI(_ notification: NotificationResponse) {
        if let url = URL(string: notification.postImageUrl), let data = try? Data(contentsOf: url) {
            imageView.image = UIImage(data: data)
        }
        timeLabel.text = notification.date.convertTimePassedString()
        
        let title = notification.title
        messageLabel.text = title

        if title.contains("프로젝트에 지원했습니다.") {
            let suffix = "프로젝트에 지원했습니다."
            var projectName = title
                        
            if let range = projectName.range(of: suffix) {
                projectName.removeSubrange(range)
                let attributedText = NSMutableAttributedString()
                    .font(projectName, ofSize: 16, weight: .bold)
                    .font(suffix, ofSize: 16, weight: .regular)
                
                messageLabel.attributedText = attributedText
            }
        }
    }

}
