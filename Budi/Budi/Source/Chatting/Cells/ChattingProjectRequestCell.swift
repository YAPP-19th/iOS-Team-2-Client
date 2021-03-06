//
//  ChattingProjectRequestCell.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/09.
//

import UIKit

protocol ChattingProjectRequestCellDelegate: AnyObject {
    func acceptApply()
}

final class ChattingProjectRequestCell: UICollectionViewCell {
    
    @IBOutlet private weak var projectNameLabel: UILabel!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var acceptButton: UIButton!
    @IBAction private func acceptButtonTapped(_ sender: Any) {
        delegate?.acceptApply()
    }
    
    weak var delegate: ChattingProjectRequestCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureUI(_ message: ChatMessage) {
        projectNameLabel.text = message.projectTitle
        timeLabel.text = message.timestamp.convertToahhmm()
        
        let fontSize: CGFloat = 15
        let attributedText = NSMutableAttributedString(string: "")
            .font(message.senderUsername, ofSize: fontSize, weight: .bold)
            .font("님이 위 프로젝트에 ", ofSize: fontSize, weight: .regular)
            .font(message.positionName, ofSize: fontSize, weight: .bold)
            .font("로 참여 요청을 보냈습니다.", ofSize: fontSize, weight: .regular)
        messageLabel.attributedText = attributedText
        
        if let url = URL(string: message.senderProfileImageUrl), let data = try? Data(contentsOf: url) {
            profileImageView.image = UIImage(data: data)
        }
    }
}
