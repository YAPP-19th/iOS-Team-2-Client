//
//  TeamRecruitmentWritingPartCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/10/14.
//

import UIKit

final class TeamRecruitmentWritingPartCell: UICollectionViewCell {

    @IBOutlet weak var partTextField: UITextField!

    private let parts = ["기획", "디자인", "개발"]
    private var part = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        createPickerView()
        createToolBar()
    }
}

extension TeamRecruitmentWritingPartCell: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        parts.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        parts[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        part = parts[row]
        partTextField.text = parts[row]
    }
}

private extension TeamRecruitmentWritingPartCell {
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        partTextField.inputView = pickerView
        partTextField.tintColor = .clear
    }

    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.setItems([.init(title: "선택", style: .plain, target: self, action: #selector(dismissPickerView))], animated: true)
        toolBar.isUserInteractionEnabled = true
        partTextField.inputAccessoryView = toolBar
    }

    @objc func dismissPickerView() {
        endEditing(true)
    }
}
