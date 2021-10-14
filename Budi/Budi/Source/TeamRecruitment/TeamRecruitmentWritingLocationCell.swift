//
//  TeamRecruitmentWritingLocationCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/10/14.
//

import UIKit

final class TeamRecruitmentWritingLocationCell: UICollectionViewCell {

    @IBOutlet weak var locationTextField: UITextField!

    private let locations = ["온라인/오프라인 모두 참여 가능", "온라인 참여 가능", "오프라인 참여 가능"]

    private var location = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        createPickerView()
        createToolBar()
    }
}

extension TeamRecruitmentWritingLocationCell: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        locations.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        locations[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        location = locations[row]
        locationTextField.text = locations[row]
    }
}

private extension TeamRecruitmentWritingLocationCell {
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        locationTextField.inputView = pickerView
        locationTextField.tintColor = .clear
    }

    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.setItems([.init(title: "선택", style: .plain, target: self, action: #selector(dismissPickerView))], animated: true)
        toolBar.isUserInteractionEnabled = true
        locationTextField.inputAccessoryView = toolBar
    }

    @objc func dismissPickerView() {
        endEditing(true)
    }
}
