//
//  DefaultTableViewCell.swift
//  Budi
//
//  Created by 인병윤 on 2021/12/01.
//

import UIKit
import Combine

final class DefaultTableViewCell: UITableViewCell {

    static let cellId = "DefaultTableViewCell"
    var cancellables = Set<AnyCancellable>()

    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var selectMainTitle: UILabel!
    @IBOutlet weak var selectDayLabel: UILabel!
    @IBOutlet weak var selectTeamLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!

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
    
}
