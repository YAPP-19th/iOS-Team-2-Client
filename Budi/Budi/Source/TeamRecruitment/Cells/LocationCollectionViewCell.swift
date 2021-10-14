//
//  LocationCollectionViewCell.swift
//  Budi
//
//  Created by ITlearning on 2021/10/13.
//

import UIKit

class LocationCollectionViewCell: UICollectionViewCell {
    
    let pickerArray = ["온/오프라인 모두 참여 가능", "오프라인만 참여 가능", "온라인만 참여 가능"]
    var selectType = ""
    @IBOutlet weak var typePicker: UITextField!
    let pickerView = UIPickerView()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configurePicker()
    }
    func configurePicker() {
        pickerView.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: 220)
        pickerView.delegate = self
        pickerView.dataSource = self
        let pickerToolBar: UIToolbar = UIToolbar()
        pickerToolBar.barStyle = .default
        pickerToolBar.isTranslucent = true
        pickerToolBar.backgroundColor = .lightGray
        pickerToolBar.sizeToFit()
        
        let btnDone = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(onPickDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let btnCancel = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(onPickCancel))
        pickerToolBar.setItems([btnCancel,space,btnDone], animated: true)
        pickerToolBar.isUserInteractionEnabled = true
        
        typePicker.inputView = pickerView
        typePicker.inputAccessoryView = pickerToolBar
    }
    @objc
    func onPickDone() {
        typePicker.text = selectType
        typePicker.resignFirstResponder()
        selectType = ""
    }
    @objc
    func onPickCancel() {
        typePicker.resignFirstResponder()
        selectType = ""
    }
}

extension LocationCollectionViewCell: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectType = pickerArray[row]
    }
}
