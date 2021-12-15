//
//  HistoryDateWriteView.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/25.
//

import UIKit
import CombineCocoa
import Combine

class HistoryDateWriteView: UIView {

    private var cancellables = Set<AnyCancellable>()
    @IBOutlet weak var leftTextField: UITextField!
    @IBOutlet weak var rightTextField: UITextField!
    @IBOutlet weak var workingCheckButton: UIButton!
    @IBOutlet weak var midTextLabel: UILabel!

    private var leftDatePicker = UIDatePicker()
    private var rightDatePicker = UIDatePicker()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        setDatePick()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
        setDatePick()
    }

    private func setDatePick() {
        leftDatePicker.datePublisher
            .receive(on: DispatchQueue.main)
            .sink { date in
                print(date)
                let text = self.dateFormatter(date)
                self.leftTextField?.text = text
            }
            .store(in: &cancellables)

        rightDatePicker.datePublisher
            .receive(on: DispatchQueue.main)
            .sink { date in
                let text = self.dateFormatter(date)
                self.rightTextField?.text = text
            }
            .store(in: &cancellables)

        workingCheckButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                if !self.workingCheckButton.isSelected {
                    self.workingCheckButton.isSelected = true
                    self.workingCheckButton.imageView?.image = UIImage(systemName: "checkmark.circle.fill")
                    self.workingCheckButton.tintColor = UIColor.budiGreen
                } else {
                    self.workingCheckButton.isSelected = false
                    self.workingCheckButton.imageView?.image = UIImage(systemName: "checkmark.circle")
                    self.workingCheckButton.tintColor = UIColor.systemGray
                }
            }
            .store(in: &cancellables)

    }

    private func dateFormatter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년MM월dd일"
        return formatter.string(from: date)
    }

    func checkButtonRemove() {
        workingCheckButton.removeFromSuperview()
        self.layoutIfNeeded()
    }

    private func initialize() {

        guard let view = Bundle.main.loadNibNamed("HistoryDateWriteView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        addSubview(view)
        leftDatePicker.datePickerMode = .date
        leftDatePicker.locale = Locale(identifier: "ko-KR")
        rightDatePicker.datePickerMode = .date
        rightDatePicker.locale = Locale(identifier: "ko-KR")
        leftTextField.inputView = leftDatePicker
        leftTextField.tintColor = UIColor.clear

        rightTextField.inputView = rightDatePicker
        rightDatePicker.tintColor = UIColor.clear

        leftTextField.text = ""
        rightTextField.text = ""
    }

}
