//
//  HomeWritingDescriptionCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/02.
//

import UIKit

protocol HomeWritingDescriptionCellDelegate: AnyObject {
}

final class HomeWritingDescriptionCell: UICollectionViewCell {
    
    weak var delegate: HomeWritingDescriptionCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
