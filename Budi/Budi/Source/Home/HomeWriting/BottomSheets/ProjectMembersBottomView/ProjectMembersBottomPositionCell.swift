//
//  ProjectMembersBottomPositionCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/20.
//

import UIKit

final class ProjectMembersBottomPositionCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureUI(position: Position) {
        label.text = position.jobStringValue
        imageView.image = position.characterBackgroundGrayImage
    }
    
    func configureSelectedUI(position: Position, selectedPosition: Position) {
        label.text = position.jobStringValue
        if position == selectedPosition {
            label.textColor = .primary
            label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            imageView.image =  position.characterBackgroundImage
        } else {
            label.textColor = .textDisabled
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            imageView.image =  position.characterBackgroundGrayImage
        }
    }
}
