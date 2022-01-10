//
//  ProjectTableViewCell.swift
//  Budi
//
//  Created by 인병윤 on 2022/01/10.
//

import UIKit
import Combine

class ProjectTableViewCell: UITableViewCell {

    var cancellables = Set<AnyCancellable>()
    static let cellId = "ProjectTableViewCell"

    @IBOutlet weak var selectMainTitleLabel: UILabel!
    @IBOutlet weak var selectDayLabel: UILabel!
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var selectTeamLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureLabel(main: String, date: String, sub: String) {
        selectView.isHidden = false
        selectMainTitleLabel.text = main
        selectDayLabel.text = date
        selectTeamLabel.text = sub
        self.bringSubviewToFront(moreButton)
    }

    func configureButtonTitle(text: String) {
        addButton.setTitle(text, for: .normal)
    }
}
