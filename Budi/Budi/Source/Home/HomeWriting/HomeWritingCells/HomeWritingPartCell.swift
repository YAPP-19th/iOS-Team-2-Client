//
//  HomeWritingPartCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/02.
//

import UIKit

final class HomeWritingPartCell: UICollectionViewCell {
    
    @IBOutlet weak var selectPartButton: UIButton!
    @IBOutlet private weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureUI(_ part: String) {
        textField.text = part
    }
}
