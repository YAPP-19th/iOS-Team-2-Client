//
//  MyBudiEditHeaderView.swift
//  Budi
//
//  Created by 인병윤 on 2022/01/10.
//

import UIKit

class MyBudiEditHeaderView: UITableViewHeaderFooterView {

    static let cellId  = "MyBudiEditHeaderView"

    @IBOutlet weak var headerLabel: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()

    }

    func configureHeader(header: String) {
        headerLabel.text = header
    }
}
