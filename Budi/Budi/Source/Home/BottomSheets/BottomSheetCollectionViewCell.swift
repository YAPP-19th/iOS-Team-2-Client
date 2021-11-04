//
//  BottomSheetCollectionViewCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit

class BottomSheetCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var checkButtonCircle: UIView!
    @IBAction func checkButtonTapped(_ sender: Any) {
        checkButtonTapped()
    }

    private var isChecked: Bool = false
    var jobGroup: String? {
        didSet {
            textLabel.text = jobGroup
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

private extension BottomSheetCollectionViewCell {
    func checkButtonTapped() {
        isChecked.toggle()

        let green = UIColor(named: "Green") ?? .systemGreen
        let lightGreen = UIColor(named: "LightGreen") ?? .systemGreen
        let lightGray = UIColor(named: "LightGray") ?? .systemGreen
        checkButton.tintColor = isChecked ? green : .white
        checkButtonCircle.borderColor = isChecked ? lightGreen : lightGray
    }
}
