//
//  ProjectMembersBottomDetailCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/15.
//

import UIKit

final class ProjectMembersBottomDetailCell: UICollectionViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureUI(_ detailPosition: String) {
        label.text = detailPosition
    }
    
    func configureSelectedUI(_ isSelected: Bool) {
        if isSelected {
            containerView.backgroundColor = .primarySub
            containerView.borderColor = .primary
            label.textColor = .primary
        } else {
            containerView.backgroundColor = .white
            containerView.borderColor = .border
            label.textColor = .textHigh
        }
    }
}
