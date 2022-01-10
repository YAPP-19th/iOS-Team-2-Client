//
//  PortfolioURLTableViewCell.swift
//  Budi
//
//  Created by 인병윤 on 2021/12/26.

import UIKit
import Combine

class PortfolioURLTableViewCell: UITableViewCell {

    static let cellId = "PortfolioURLTableViewCell"
    var cancellables = Set<AnyCancellable>()
    @IBOutlet weak var portfolioView: UIView!
    @IBOutlet weak var portfolioUrlFaviconImageView: UIImageView!
    @IBOutlet weak var portfolioUrlLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
        portfolioView.isHidden = true
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        portfolioView.isHidden = true
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func configureParsing(url: String) {
        portfolioView.isHidden = false
        let sep = url.split(separator: "/")
        if sep[0] == "https:" {
            switch sep[1] {
            case "www.behance.net":
                portfolioUrlFaviconImageView.image = UIImage(named: "Behance")
            case "www.linkedin.com":
                portfolioUrlFaviconImageView.image = UIImage(named: "Linkedin")
            case "www.instagram.com":
                portfolioUrlFaviconImageView.image = UIImage(named: "Instagram")
            default:
                portfolioUrlFaviconImageView.image = UIImage(named: "Others")
            }
        }
        portfolioUrlLabel.text = url
    }

    func configureButtonLabel(text: String) {
        addButton.setTitle(text, for: .normal)
    }
}
