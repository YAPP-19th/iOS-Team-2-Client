//
//  HistoryAddButtonView.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/28.
//

import UIKit

class HistoryAddButtonView: UIView {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var greenView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        configureLayout()

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
        configureLayout()
    }

    private func initialize() {
        guard let view = Bundle.main.loadNibNamed("HistoryAddButtonView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        addSubview(view)
    }

    private func configureLayout() {
        greenView.cornerRadius = 8
    }

    func setButtonTitle(_ title: String) {
        addButton.setTitle(title, for: .normal)
    }
}
