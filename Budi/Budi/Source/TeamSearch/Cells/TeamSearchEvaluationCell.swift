//
//  TeamSearchEvaluationCell.swift
//  Budi
//
//  Created by 최동규 on 2022/01/06.
//

import UIKit

final class TeamSearchEvaluationCell: UICollectionViewCell {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUI(title: String, count: Int) {
        titleLabel.text = title
        countLabel.text = String(count)
    }
}
