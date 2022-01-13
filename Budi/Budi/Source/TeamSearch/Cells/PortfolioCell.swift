//
//  PortfolioCell.swift
//  Budi
//
//  Created by 최동규 on 2022/01/11.
//

import UIKit

class PortfolioCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var urlLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUI(urlString: String) {
        urlLabel.text = urlString
        guard let url = URL(string: urlString) else { return }

        switch url.host {
        case "www.behance.net":
            imageView.image = UIImage(named: "Behance")
        case "www.linkedin.com":
            imageView.image = UIImage(named: "Linkedin")
        case "www.instagram.com":
            imageView.image = UIImage(named: "Instagram")
        default:
            imageView.image = UIImage(named: "Others")
        }

    }
}
