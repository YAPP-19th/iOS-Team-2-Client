//
//  ChattingMessageEmojiCell.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/13.
//

import UIKit

final class ChattingMessageEmojiCell: UICollectionViewCell {

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
    }
}
