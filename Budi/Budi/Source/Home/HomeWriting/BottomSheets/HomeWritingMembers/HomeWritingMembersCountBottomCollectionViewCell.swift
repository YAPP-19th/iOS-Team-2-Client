//
//  HomeWritingMembersCountBottomCollectionViewCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/15.
//

import UIKit

protocol HomeWritingMembersCountBottomCollectionViewCellDelegate: AnyObject {
    func addRecruitingPosition(_ recruitingPosition: RecruitingPosition)
}

final class HomeWritingMembersCountBottomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var partLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    
    var recruitingPosition: RecruitingPosition? {
        didSet {
            DispatchQueue.main.async {
                self.configureUI()
            }
        }
    }
    
    weak var delegate: HomeWritingMembersCountBottomCollectionViewCellDelegate?
    
    @IBAction func minusButtonTapped(_ sender: Any) {
        if recruitingPosition?.recruitingNumber ?? 0 > 1 {
            recruitingPosition?.recruitingNumber -= 1
            guard let recruitingPosition = recruitingPosition else { return }
            delegate?.addRecruitingPosition(recruitingPosition)
            countLabel.text = String(recruitingPosition.recruitingNumber)
        }
    }
    @IBAction func plusButtonTapped(_ sender: Any) {
        recruitingPosition?.recruitingNumber += 1
        if let recruitingPosition = recruitingPosition {
            delegate?.addRecruitingPosition(recruitingPosition)
        }
        if let count = recruitingPosition?.recruitingNumber {
            countLabel.text = String(count)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.addBorderBottom()
    }
    
    func configureUI() {
        if let recruitingPosition = recruitingPosition {
            partLabel.text = recruitingPosition.positionName
            countLabel.text = String(recruitingPosition.recruitingNumber)
        }
    }
}
