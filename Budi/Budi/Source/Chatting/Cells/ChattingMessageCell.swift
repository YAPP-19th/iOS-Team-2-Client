//
//  ChattingMessageCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit

final class ChattingMessageCell: UICollectionViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureUI(_ message: ChatMessage) {
        messageLabel.text = message.text
        timeLabel.text = message.timestamp.convertToahhmm()
        
//        if message.text.isSingleEmoji {
//            messageLabel.font = UIFont.systemFont(ofSize: 80)
//            containerView.backgroundColor = .clear
//        }
    }
}
