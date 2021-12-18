//
//  HistoryResultView.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/27.
//

import UIKit

class HistoryResultView: UIView {

    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subDayTitleLabel: UILabel!
    @IBOutlet weak var teamTitleLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        guard let view = Bundle.main.loadNibNamed("HistoryResultView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        addSubview(view)
    }

    func configureTitle(main: String, sub: String, team: String) {
        mainTitleLabel.text = main
        subDayTitleLabel.text = sub
        teamTitleLabel.text = team
    }

}
