//
//  HomeWritingDescriptionCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/02.
//

import UIKit

protocol HomeWritingDescriptionCellDelegate: AnyObject {
    func changeDescription(_ description: String)
}

final class HomeWritingDescriptionCell: UICollectionViewCell {
    
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var placeholderTextView: UITextView!
    
    weak var delegate: HomeWritingDescriptionCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        configureTextView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.endEditing(true)
    }
}

extension HomeWritingDescriptionCell: HomeWritingViewControllerDelegate {
    func collectionViewDidScroll() {
        textView.endEditing(true)
    }
}

extension HomeWritingDescriptionCell: UITextViewDelegate {
    private func configureTextView() {
        textView.delegate = self
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        if text.isEmpty {
            placeholderTextView.alpha = 1
        } else {
            placeholderTextView.alpha = 0
            delegate?.changeDescription(text)
        }
    }
}
