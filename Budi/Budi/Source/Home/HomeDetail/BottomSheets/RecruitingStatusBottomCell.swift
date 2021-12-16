//
//  HomeDetailBottomSheetCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit

final class RecruitingStatusBottomCell: UICollectionViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var circleContainerView: UIView!
    @IBOutlet private weak var circleView: UIView!

    var recruitingStatus: RecruitingStatus? {
        didSet {
            textLabel.text = recruitingStatus?.positionName
        }
    }
    var isChecked: Bool = false {
        didSet {
            configureUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func configureUI() {
        containerView.borderColor = isChecked ? .budiGreen : .budiLightGray
        circleContainerView.borderColor = isChecked ? .budiLightGreen : .budiLightGray
        circleView.backgroundColor = isChecked ? .budiGreen : .white
    }
}