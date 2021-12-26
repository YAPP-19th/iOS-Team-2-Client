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

    @IBOutlet private weak var startDateTextField: UITextField!
    @IBOutlet private weak var endDateTextField: UITextField!
    
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
    
    func configureUI(_ startDate: Date?, _ endDate: Date?) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.timeZone = TimeZone(abbreviation: "Asia/Seoul")
        
        if let startDate = startDate {
            startDateTextField.text = formatter.string(from: startDate)
        }
        if let endDate = endDate {
            endDateTextField.text = formatter.string(from: endDate)
        }
    }
}
