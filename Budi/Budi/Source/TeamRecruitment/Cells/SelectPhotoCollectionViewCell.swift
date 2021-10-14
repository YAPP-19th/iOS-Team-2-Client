//
//  SelectPhotoCollectionViewCell.swift
//  Budi
//
//  Created by ITlearning on 2021/10/13.
//

import UIKit

class SelectPhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var selectView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        configureSelect()
    }
    private func configureSelect() {
        selectView.layer.borderWidth = 1
        selectView.backgroundColor = .white
        selectView.layer.borderColor = UIColor.systemGray4.cgColor
        selectView.layer.cornerRadius = 5
        selectView.layer.masksToBounds = true
    }
}
