//
//  PositionTableViewCell.swift
//  Budi
//
//  Created by 인병윤 on 2022/01/10.
//

import UIKit

class LocationReplaceTableViewCell: UITableViewCell {

    static let cellId = "LocationReplaceTableViewCell"

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var replaceLocationButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureLocation(location: String) {
        locationTextField.text = location
    }

}
