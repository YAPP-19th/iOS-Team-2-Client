//
//  HomeWritingAreaCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/02.
//

import UIKit

final class HomeWritingAreaCell: UICollectionViewCell {
    
    @IBOutlet private weak var areaTextField: UITextField!
    @IBOutlet weak var selectButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureUI(_ area: String) {
        areaTextField.text = area
    }
}
