//
//  SearchTableViewCell.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/08.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    static let cellId = "SearchTableCell"

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCellLabel(text: String) {
        locationLabel.text = text
    }

    private func configureLayout() {
        addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            locationLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        ])
    }

}
