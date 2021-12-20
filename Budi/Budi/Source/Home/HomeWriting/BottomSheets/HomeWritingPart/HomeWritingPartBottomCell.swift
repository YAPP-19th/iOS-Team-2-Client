//
//  HomeWritingPartBottomCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/14.
//

import UIKit

final class HomeWritingPartBottomCell: UICollectionViewCell {

    @IBOutlet private weak var circleContainerView: UIView!
    @IBOutlet private weak var circleView: UIView!
    @IBOutlet private weak var partLabel: UILabel!
    
    private var isChecked: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureUI(_ part: String) {
        partLabel.text = part
    }
    
    func configureSelectedUI() {
        circleContainerView.borderColor = .budiLightGreen
        circleView.backgroundColor = .budiGreen
    }
    
    func configureDeselectedUI() {
        circleContainerView.borderColor = .budiLightGray
        circleView.backgroundColor = .white
    }
}
