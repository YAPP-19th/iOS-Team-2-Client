//
//  ProjectMembersBottomDetailCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/15.
//

import UIKit

final class ProjectMembersBottomDetailCell: UICollectionViewCell {

    @IBOutlet private weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureUI(_ detailPosition: String) {
        label.text = detailPosition
    }
    
    func configureSelectedUI(_ isSelected: Bool) {
        if isSelected {
            backgroundColor = .primarySub
            borderColor = .primary
            label.textColor = .primary
        } else {
            backgroundColor = .white
            borderColor = .border
            label.textColor = .textHigh
        }
    }
}
