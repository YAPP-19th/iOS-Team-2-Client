//
//  HistoryNoCheckDateView.swift
//  Budi
//
//  Created by 인병윤 on 2021/12/15.
//

import UIKit
import Combine
import CombineCocoa

class HistoryNoCheckDateView: UIView {
    private var cancellables = Set<AnyCancellable>()
    @IBOutlet weak var rightTextField: UITextField!
    @IBOutlet weak var leftTextField: UITextField!
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
    }

    private func dateFormatter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년MM월dd일"
        return formatter.string(from: date)
    }

    private func initialize() {

        guard let view = Bundle.main.loadNibNamed("HistoryDateWriteView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        addSubview(view)
//        leftDatePicker.datePickerMode = .date
//        leftDatePicker.locale = Locale(identifier: "ko-KR")
//        rightDatePicker.datePickerMode = .date
//        rightDatePicker.locale = Locale(identifier: "ko-KR")
//        leftTextField.inputView = leftDatePicker
//        leftTextField.tintColor = UIColor.clear
//
//        rightTextField.inputView = rightDatePicker
//        rightDatePicker.tintColor = UIColor.clear
//
//        leftTextField.text = ""
//        rightTextField.text = ""
    }

}
