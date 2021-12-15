//
//  HomeWritingDurationCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/02.
//

import UIKit

protocol HomeWritingDurationCellDelegate: AnyObject {
    func showDatePickerBottomView(_ isStartDate: Bool)
}

final class HomeWritingDurationCell: UICollectionViewCell {
    
    @IBOutlet private weak var startTimeTextField: UITextField!
    @IBOutlet private weak var endTimeTextField: UITextField!
    
    @IBAction private func startTimeContainerButtonTapped(_ sender: Any) {
        delegate?.showDatePickerBottomView(true)
    }
    @IBAction private func endTimeContainerButtonTapped(_ sender: Any) {
        delegate?.showDatePickerBottomView(false)
    }
    
    weak var delegate: HomeWritingDurationCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
