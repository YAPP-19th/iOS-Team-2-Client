//
//  MyBudiHelpCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/22.
//

import UIKit
import Combine
import CombineCocoa

final class MyBudiHelpCell: UICollectionViewCell {
    var cancellables = Set<AnyCancellable>()
    @IBOutlet weak var logoutButton: UIButton!

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
