//
//  BottomSheetCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit

class BottomSheetCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var checkButtonCircle: UIView!
    @IBAction func checkButtonTapped(_ sender: Any) {
        checkButtonTapped()
    }

    private var isChecked: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateUI(status: RecruitingStatusResponse) {
        textLabel.text = status.positionName
    }
}

private extension BottomSheetCell {
    func checkButtonTapped() {
        isChecked.toggle()

        checkButton.tintColor = isChecked ? UIColor.budiGreen : .white
        checkButtonCircle.borderColor = isChecked ? UIColor.budiLightGreen : UIColor.budiLightGray
        containerView.borderColor = isChecked ? UIColor.budiGreen : UIColor.budiLightGray
    }
}
