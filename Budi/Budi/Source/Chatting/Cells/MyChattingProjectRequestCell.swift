//
//  MyChattingProjectRequestCell.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/22.
//

import UIKit

protocol MyChattingProjectRequestCellDelegate: AnyObject {
    func acceptApply()
}

final class MyChattingProjectRequestCell: UICollectionViewCell {

    @IBOutlet private weak var projectNameLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var acceptButton: UIButton!
    @IBOutlet private weak var timeLabel: UILabel!
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
    }
}
