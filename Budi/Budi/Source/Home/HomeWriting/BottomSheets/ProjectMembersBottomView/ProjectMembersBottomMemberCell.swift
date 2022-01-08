//
//  ProjectMembersBottomMemberCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/15.
//

import UIKit

protocol ProjectMembersBottomMemberCellDelegate: AnyObject {
    func editRecruitingPosition(_ recruitingPosition: RecruitingPosition)
}

final class ProjectMembersBottomMemberCell: UICollectionViewCell {
    
    @IBOutlet private weak var partLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    
    var recruitingPosition: RecruitingPosition?
    
    weak var delegate: ProjectMembersBottomMemberCellDelegate?
    
    @IBAction func minusButtonTapped(_ sender: Any) {
        if recruitingPosition?.recruitingNumber ?? 0 > 1 {
            recruitingPosition?.recruitingNumber -= 1
        }
        if let recruitingPosition = recruitingPosition {
            delegate?.editRecruitingPosition(recruitingPosition)
        }
    }
    @IBAction func plusButtonTapped(_ sender: Any) {
        recruitingPosition?.recruitingNumber += 1
        if let recruitingPosition = recruitingPosition {
            delegate?.editRecruitingPosition(recruitingPosition)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureUI(_ recruitingPosition: RecruitingPosition) {
        self.recruitingPosition = recruitingPosition
        partLabel.text = recruitingPosition.positionName
        countLabel.text = String(recruitingPosition.recruitingNumber)
    }
}
