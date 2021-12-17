//
//  DefaultHeaderView.swift
//  Budi
//
//  Created by 인병윤 on 2021/12/01.
//

import UIKit
import Combine
import CombineCocoa

class DefaultHeaderView: UITableViewHeaderFooterView {
    static let cellId = "DefaultHeaderView"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    var cancellables = Set<AnyCancellable>()

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        
        cancellables.removeAll()
    }

    func configureLabel(title: String) {
        titleLabel.text = title
    }
}
