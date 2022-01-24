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
        
        if let date = notification.date.date() {
            timeLabel.text = date.convertTimePassedString()
        }
        
        let title = notification.title
        messageLabel.text = title
        
        if title.contains("프로젝트에 지원했습니다.") {
            let attributedText = NSMutableAttributedString(string: title)
            
            attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .bold), range: (title as NSString).range(of: notification.postTitle))
            messageLabel.attributedText = attributedText
        }
    }
}
