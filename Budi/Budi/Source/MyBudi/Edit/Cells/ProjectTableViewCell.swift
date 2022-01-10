//
//  ProjectTableViewCell.swift
//  Budi
//
//  Created by 인병윤 on 2022/01/10.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    static let cellId = "ProjectTableViewCell"

    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var addButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureButtonTitle(text: String) {
        addButton.setTitle(text, for: .normal)
    }
}
