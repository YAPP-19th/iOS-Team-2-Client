//
//  HomeWritingMembersCountBottomCollectionViewCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/15.
//

import UIKit

protocol HomeWritingMembersCountBottomCollectionViewCellDelegate: AnyObject {
    func getCount(_ count: Int)
}

final class HomeWritingMembersCountBottomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var containerView: UIView!
    
    @IBOutlet private weak var partLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    
    @IBAction func minusButtonTapped(_ sender: Any) {
        if count > 1 {
            count -= 1
            countLabel.text = String(count)
            delegate?.getCount(count)
        }
    }
    @IBAction func plusButtonTapped(_ sender: Any) {
        count += 1
        countLabel.text = String(count)
        delegate?.getCount(count)
    }
    
    private var count: Int = 1
    
    weak var delegate: HomeWritingMembersCountBottomCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.addBorderBottom()
    }
}
