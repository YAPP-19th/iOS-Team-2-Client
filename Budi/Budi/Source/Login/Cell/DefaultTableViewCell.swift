//
//  DefaultTableViewCell.swift
//  Budi
//
//  Created by 인병윤 on 2021/12/01.
//

import UIKit
import Combine

final class DefaultTableViewCell: UITableViewCell {

    static let cellId = "DefaultTableViewCell"
    var cancellables = Set<AnyCancellable>()

    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var selectMainTitle: UILabel!
    @IBOutlet weak var selectDayLabel: UILabel!
    @IBOutlet weak var selectTeamLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var portfolioLinkLabel: UILabel!
    @IBOutlet weak var portfolioView: UIView!
    override func prepareForReuse() {
        super.prepareForReuse()
        selectView.isHidden = true
        portfolioView.isHidden = true
        cancellables.removeAll()
    }

    override func awakeFromNib() {

        super.awakeFromNib()
        portfolioView.isHidden = true
        selectView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureLabel(main: String, date: String, sub: String) {
        selectView.isHidden = false
        selectMainTitle.text = main
        selectDayLabel.text = date
        selectTeamLabel.text = sub
        self.bringSubviewToFront(moreButton)
    }

    func configurePortfolioLabel(link: String) {
        portfolioView.isHidden = false
        portfolioLinkLabel.text = link
    }

    func configureButtonTitle(title: String) {
        addButton.setTitle(title, for: .normal)
    }
    
}
