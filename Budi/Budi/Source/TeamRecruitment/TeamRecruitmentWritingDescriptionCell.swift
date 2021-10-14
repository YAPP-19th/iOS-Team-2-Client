//
//  TeamRecruitmentWritingDescriptionCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/10/14.
//

import UIKit

final class TeamRecruitmentWritingDescriptionCell: UICollectionViewCell {

    @IBOutlet weak var descriptionTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextView()
    }
}

extension TeamRecruitmentWritingDescriptionCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
    }
}

private extension TeamRecruitmentWritingDescriptionCell {
    func setupTextView() {
        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        descriptionTextView.layer.cornerRadius = 8
    }
}
