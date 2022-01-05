//
//  TeamSearchCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit

final class TeamSearchCell: UICollectionViewCell {

    @IBOutlet private weak var headerImageView: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var headerTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func updateUI(_ post: Post) {
    }

}

private extension TeamSearchCell {
    func configure() {

    }
}
