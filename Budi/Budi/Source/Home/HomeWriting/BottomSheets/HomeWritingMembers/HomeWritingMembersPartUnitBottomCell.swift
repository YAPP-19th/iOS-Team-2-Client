//
//  HomeWritingMembersPartUnitBottomCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/20.
//

import UIKit

class HomeWritingMembersPartUnitBottomCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var position: Position? {
        didSet {
            if let position = position {
                configureUI(position)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureUI(_ position: Position) {
        label.text = position.rawValue
        if let image = position.characterBackgroundGrayImage {
            imageView.image = image
        }
    }
    
    func configureSelectedUI() {
        label.textColor = .primary
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        if let image = position?.characterBackgroundImage {
            imageView.image = image
        }
    }
    
    func configureDeselectedUI() {
        label.textColor = .textDisabled
        label.font = .systemFont(ofSize: 14, weight: .regular)
        if let image = position?.characterBackgroundGrayImage {
            imageView.image = image
        }
    }
}
