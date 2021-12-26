//
//  PositionLabelCell.swift
//  Budi
//
//  Created by 최동규 on 2021/12/18.
//

import UIKit

final class PositionLabelCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 25 / 2
        backgroundColor = .systemBlue
        // Initialization code
    }

}
