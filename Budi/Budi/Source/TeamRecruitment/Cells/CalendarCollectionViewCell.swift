//
//  CalendarCollectionViewCell.swift
//  Budi
//
//  Created by ITlearning on 2021/10/13.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var datePickerView: UIDatePicker!
    override func awakeFromNib() {
        super.awakeFromNib()
        datePickerView.preferredDatePickerStyle = .compact
        configureLayout()
    }
    func configureLayout() {
        datePickerView.translatesAutoresizingMaskIntoConstraints = true
        datePickerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        datePickerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }

}
