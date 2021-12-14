//
//  HomeWritingAreaCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/02.
//

import UIKit

protocol HomeWritingAreaCellDelegate: AnyObject {
}

final class HomeWritingAreaCell: UICollectionViewCell {
    
    weak var delegate: HomeWritingAreaCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
