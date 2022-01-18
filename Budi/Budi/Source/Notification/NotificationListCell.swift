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

        let appliedSentence = "프로젝트에 지원했습니다."
        
        if title.contains(appliedSentence) {
            let attributedText = NSMutableAttributedString()
                .font(notification.postTitle, ofSize: 16, weight: .bold)
                .font(" " + appliedSentence, ofSize: 16, weight: .regular)
            
            messageLabel.attributedText = attributedText
        }
    }
}
