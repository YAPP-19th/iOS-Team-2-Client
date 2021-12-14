//
//  HomeWritingDurationCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/02.
//

import UIKit
import Combine
import CombineCocoa

protocol HomeWritingDurationCellDelegate: AnyObject {
    func changeStartDate(_ dateString: String)
    func changeEndDate(_ dateString: String)
}

final class HomeWritingDurationCell: UICollectionViewCell {
    
    @IBOutlet private weak var startTimeContainerButton: UIButton!
    @IBOutlet private weak var endTimeContainerButton: UIButton!
    
    @IBOutlet private weak var startTimeTextField: UITextField!
    @IBOutlet private weak var endTimeTextField: UITextField!
    
    @IBOutlet private weak var startDatePicker: UIDatePicker!
    @IBOutlet private weak var endDatePicker: UIDatePicker!
    
    @IBAction private func startDatePickerTapped(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let date = dateFormatter.string(from: startDatePicker.date)
    
        startTimeTextField.text = date
        delegate?.changeStartDate(date)
    }
    @IBAction private func endDatePickerTapped(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let date = dateFormatter.string(from: startDatePicker.date)
        
        endTimeTextField.text = date
        delegate?.changeEndDate(date)
    }
    
    weak var delegate: HomeWritingDurationCellDelegate?
    private var cancellables = Set<AnyCancellable>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setPublisher()
    }
}

private extension HomeWritingDurationCell {
    func setPublisher() {
        startTimeContainerButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                // startDatePicker 날짜선택 창 띄우는 코드
            }.store(in: &cancellables)
        
        endTimeContainerButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                // startDatePicker 날짜선택 창 띄우는 코드
            }.store(in: &cancellables)
    }
}
