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
            switch post.positions[indexPath.item].colorCode {
            case 1:
                cell.backgroundColor = .init(hexString: "#FEEDED")
                cell.label.textColor = .init(hexString: "#E96262")
            case 2:
                cell.backgroundColor = .init(hexString: "#E7F1FB")
                cell.label.textColor = .init(hexString: "#3382E0")
            case 3:
                cell.backgroundColor = .init(hexString: "#E8F8F5")
                cell.label.textColor = .init(hexString: "#40C1A2")
            default:
                break
            }
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

// https://stackoverflow.com/questions/22539979/left-align-cells-in-uicollectionview

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }

        return attributes
    }
}
