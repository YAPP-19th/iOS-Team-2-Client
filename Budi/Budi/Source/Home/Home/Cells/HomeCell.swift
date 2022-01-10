//
//  HomeCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/02.
//

import UIKit
import Kingfisher

final class HomeCell: UICollectionViewCell {

    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    private var post: Post?
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func updateUI(_ post: Post) {
        self.post = post
        titleLabel.text = post.title
        regionLabel.text = "[\(post.region.split(separator: " ").first ?? "" )]"
        let month = post.endDate.distance(from: post.startDate, only: .month)
        timeLabel.text = "\(post.startDate.convertStringyyyyMMdd()) - \(post.endDate.convertStringyyyyMMdd()) · \(month)개월"
        if let url = URL(string: post.imageUrl) {
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "defaultBackground"))
        }
        collectionView.reloadData()
    }
}

extension HomeCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let post = post else { return 0 }
        return post.positions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PositionLabelCell.identifier, for: indexPath) as? PositionLabelCell else { return UICollectionViewCell() }
        if let post = post {

            cell.backgroundColor = Position(rawValue: post.positions[indexPath.item].colorCode)?.labelBackgroundColor
            cell.label.textColor = Position(rawValue: post.positions[indexPath.item].colorCode)?.labelTextColor
            cell.label.text = post.positions[indexPath.item].position
        }

        return cell
    }
}

extension HomeCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let post = post else { return .zero }
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = post.positions[indexPath.item].position
        label.sizeToFit()
        label.layoutIfNeeded()
        return .init(width: label.frame.width + 24, height: 25)
    }
}

private extension HomeCell {
    func configure() {
        collectionView.delegate = self
        collectionView.dataSource = self

        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.itemSize = .init(width: 100, height: 25)
        collectionView.collectionViewLayout = layout

        collectionView.register(.init(nibName: PositionLabelCell.identifier, bundle: nil), forCellWithReuseIdentifier: PositionLabelCell.identifier)
        regionLabel.textColor = UIColor.primary
        timeLabel.textColor = UIColor.textDisabled
        backgroundColor = .systemGroupedBackground
        layer.cornerRadius = 12
        borderColor = .systemGray4
        borderWidth = 1
    }
}
