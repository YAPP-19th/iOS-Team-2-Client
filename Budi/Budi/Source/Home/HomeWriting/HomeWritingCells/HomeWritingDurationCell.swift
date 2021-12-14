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
    func showWritingDurationStartDatePicker()
    func showWritingDurationEndDatePicker()
}

final class HomeWritingDurationCell: UICollectionViewCell {
    
    @IBOutlet private weak var startTimeContainerButton: UIButton!
    @IBOutlet private weak var endTimeContainerButton: UIButton!
    
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    
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
            .sink { [weak self] _ in
                self?.delegate?.showWritingDurationStartDatePicker()
            }.store(in: &cancellables)
        
        endTimeContainerButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.delegate?.showWritingDurationEndDatePicker()
            }.store(in: &cancellables)
    }
}
