//
//  TeamRecruitmentWritingMemberCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/10/14.
//

import UIKit

final class TeamRecruitmentWritingMemberCell: UICollectionViewCell {

    @IBOutlet weak var memberMainTextField: UITextField!
    @IBOutlet weak var memberDetailTextField: UITextField!

    @IBOutlet weak var memberCountTextField: UITextField!
    @IBOutlet weak var memberPlusButton: UIButton!
    @IBOutlet weak var memberMinusButton: UIButton!

    @IBOutlet weak var memberAddBtn: UIButton!
    @IBOutlet weak var memberDeleteBtn: UIButton!

    private let mainParts = ["기획", "디자인", "개발"]
    private let detailPlanParts = ["UI/UX 기획", "서비스 기획"]
    private let detailDesignParts = ["UI/UX 디자인", "서비스 디자인"]
    private let detailDevelopmentParts = ["iOS 개발", "안드로이드 개발", "웹 개발"]

    private var mainPart = ""
    private var memberCount = 1

    override func awakeFromNib() {
        super.awakeFromNib()
        createMainPickerView()
        createDetailPickerView()
        createToolBar()
        setupCountBtns()
        setupBtns()
    }
}

extension TeamRecruitmentWritingMemberCell: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return mainParts.count
        }

        switch mainPart {
        case "기획": return detailPlanParts.count
        case "디자인": return detailDesignParts.count
        case "개발": return detailDevelopmentParts.count
        default: return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return mainParts[row]
        }

        switch mainPart {
        case "기획": return detailPlanParts[row]
        case "디자인": return detailDesignParts[row]
        case "개발": return detailDevelopmentParts[row]
        default: return ""
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            mainPart = mainParts[row]
            memberMainTextField.text = mainParts[row]
            memberDetailTextField.isEnabled = true
            return
        }

        switch mainPart {
        case "기획": memberDetailTextField.text = detailPlanParts[row]
        case "디자인": memberDetailTextField.text = detailDesignParts[row]
        case "개발": memberDetailTextField.text = detailDevelopmentParts[row]
        default: break
        }
    }
}

private extension TeamRecruitmentWritingMemberCell {
    func createMainPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.tag = 1
        memberMainTextField.inputView = pickerView
        memberMainTextField.tintColor = .clear
    }

    func createDetailPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.tag = 2
        memberDetailTextField.inputView = pickerView
        memberDetailTextField.tintColor = .clear
    }

    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.setItems([.init(title: "선택", style: .plain, target: self, action: #selector(dismissPickerView))], animated: true)
        toolBar.isUserInteractionEnabled = true
        memberMainTextField.inputAccessoryView = toolBar
        memberDetailTextField.inputAccessoryView = toolBar
    }

    @objc func dismissPickerView() {
        endEditing(true)
    }
}

private extension TeamRecruitmentWritingMemberCell {
    func setupCountBtns() {
        memberPlusButton.addTarget(self, action: #selector(plusBtnTapped), for: .touchUpInside)
        memberMinusButton.addTarget(self, action: #selector(minusBtnTapped), for: .touchUpInside)
    }

    @objc func plusBtnTapped() {
        memberCount += 1
        memberCountTextField.text = String(memberCount)
    }

    @objc func minusBtnTapped() {
        guard memberCount > 0 else { return }
        memberCount -= 1
        memberCountTextField.text = String(memberCount)
    }
}

private extension TeamRecruitmentWritingMemberCell {
    func setupBtns() {
        memberAddBtn.addTarget(self, action: #selector(addBtnTapped), for: .touchUpInside)
        memberDeleteBtn.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)
    }

    @objc func addBtnTapped() {
    }

    @objc func deleteBtnTapped() {
    }
}
