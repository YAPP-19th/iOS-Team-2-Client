//
//  HomeCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/02.
//

import UIKit
import Kingfisher

final class HomeCell: UICollectionViewCell {

    @IBOutlet weak var toolStackLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func updateUI(_ post: Post) {
        titleLabel.text = post.title
        descriptionLabel.text = post.description
        positionLabel.text = post.recruitingStatusResponses.first?.positionName
        timeLabel.text = post.createdDate.convertTimePassedString()
        toolStackLabel.text = post.recruitingStatusResponses
            .map { "#\($0.positionName)" }
            .joined(separator: " ")
        if let url = URL(string: post.imageUrl) {
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "defaultBackground"))
        }
    }
}

private extension HomeCell {
    func configure() {
        backgroundColor = .systemGroupedBackground
        layer.cornerRadius = 12
        borderColor = .systemGray4
        borderWidth = 1
    }
}
