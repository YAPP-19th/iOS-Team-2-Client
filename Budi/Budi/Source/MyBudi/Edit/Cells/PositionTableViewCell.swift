//
//  PositionTableViewCell.swift
//  Budi
//
//  Created by 인병윤 on 2022/01/10.
//

import UIKit
import Combine

class PositionTableViewCell: UITableViewCell {

    static let cellId = "PositionTableViewCell"
    var cancellables = Set<AnyCancellable>()

    @IBOutlet weak var positionTextField: UITextField!

    @IBOutlet weak var positionEditButton: UIButton!
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configurePosition(position: [String]) {
        var positionText = ""
        for position in position {
            positionText += "#\(position) "
        }
        positionTextField.text = positionText
    }
}

