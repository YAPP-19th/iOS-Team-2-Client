//
//  HomeWritingMembersCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/02.
//

import UIKit

protocol HomeWritingMembersCellDelegate: AnyObject {
}

final class HomeWritingMembersCell: UICollectionViewCell {
    
    weak var delegate: HomeWritingMembersCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
