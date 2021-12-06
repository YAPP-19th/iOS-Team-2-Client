//
//  HomeDetailDescriptionCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/02.
//

import UIKit

final class HomeDetailDescriptionCell: UICollectionViewCell {

    @IBOutlet weak var descriptionTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateUI(_ description: String) {
        descriptionTextField.text = description
    }
}
