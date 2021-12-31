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
    @IBOutlet weak var portfolioUrlFaviconImageView: UIImageView!
    @IBOutlet weak var portfolioUrlLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func configureParsing(url: String) {
        let sep = url.split(separator: "/")
        print(sep)
        portfolioUrlLabel.text = url
        portfolioUrlFaviconImageView.image = UIImage(named: "Linkedin")
    }
    
}
