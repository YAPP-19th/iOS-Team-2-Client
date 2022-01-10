//
//  NormalTextFieldTableViewCell.swift
//  Budi
//
//  Created by 인병윤 on 2022/01/10.
//

import UIKit

class NormalTextFieldTableViewCell: UITableViewCell {

    static let cellId = "NormalTextFieldTableViewCell"

    @IBOutlet weak var normalTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureLabel(text: String) {
        normalTitleLabel.text = text
    }
}
