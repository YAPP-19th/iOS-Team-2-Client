//
//  HomeWritingMembersDetailPartBottomCollectionViewCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/15.
//

import UIKit

final class HomeWritingMembersDetailPartBottomCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var label: UILabel!
    
    var isPartSelected: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if self.isPartSelected {
                    self.configureSelectedUI()
                } else {
                    self.configureDeselectedUI()
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureUI(_ position: String) {
        label.text = position
    }
    
    func configureSelectedUI() {
        containerView.backgroundColor = .primarySub
        containerView.borderColor = .primary
        label.textColor = .primary
    }
    
    func configureDeselectedUI() {
        containerView.backgroundColor = .white
        containerView.borderColor = .border
        label.textColor = .textHigh
    }
}
