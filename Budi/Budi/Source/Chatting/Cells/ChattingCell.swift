//
//  ChattingCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit

final class ChattingCell: UICollectionViewCell {

    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var positionLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var messageTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureUI(_ message: ChatMessage, _ isFromCurrentUser: Bool) {
        timeLabel.text = message.timestamp.convertToahhmm()
        messageTextLabel.text = message.text
        
        if isFromCurrentUser {
            usernameLabel.text = message.recipientUsername
            positionLabel.text = message.recipientPosition
            if let url = URL(string: message.recipientProfileImageUrl) {
                profileImageView.kf.setImage(with: url, placeholder: UIImage.defaultProfile)
            }
        } else {
            usernameLabel.text = message.senderUsername
            positionLabel.text = message.senderPosition
            if let url = URL(string: message.senderProfileImageUrl) {
                profileImageView.kf.setImage(with: url, placeholder: UIImage.defaultProfile)
            }
        }
    }
}
