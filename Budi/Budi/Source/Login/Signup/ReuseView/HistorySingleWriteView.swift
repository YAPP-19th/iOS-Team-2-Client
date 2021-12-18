//
//  HistorySingleWriteView.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/25.
//

import UIKit

class HistorySingleWriteView: UIView {

    @IBOutlet weak var singleTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        guard let view = Bundle.main.loadNibNamed("HistorySingleWriteView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        addSubview(view)
        singleTextField.cornerRadius = 8
    }

    func configureText(title: String, placeHolder: String) {
        titleLabel.text = title
        singleTextField.placeholder = placeHolder
    }
}
