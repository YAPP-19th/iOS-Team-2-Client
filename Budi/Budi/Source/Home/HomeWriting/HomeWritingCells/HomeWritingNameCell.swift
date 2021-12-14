//
//  HomeWritingNameCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/02.
//

import UIKit

protocol HomeWritingNameCellDelegate: AnyObject {
    func changeName(_ text: String)
}

final class HomeWritingNameCell: UICollectionViewCell {
    
    @IBOutlet private weak var textField: UITextField!
    
    weak var delegate: HomeWritingNameCellDelegate?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTextField()
    }
}

extension HomeWritingNameCell: UITextFieldDelegate {
    private func configureTextField() {
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(
            _:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            print(text)
            delegate?.changeName(text)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
