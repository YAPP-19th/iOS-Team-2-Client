//
//  HomeWritingMembersDetailPartBottomCollectionViewCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/15.
//

import UIKit

final class HomeWritingMembersDetailPartBottomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var partButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureUI(_ partString: String) {
        partButton.setTitle(partString, for: .normal)
    }
}
