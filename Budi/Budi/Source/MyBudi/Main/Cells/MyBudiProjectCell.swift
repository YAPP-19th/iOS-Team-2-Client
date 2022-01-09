//
//  MyBudiProjectCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/21.
//

import UIKit
import Combine
import CombineCocoa

final class MyBudiProjectCell: UICollectionViewCell {

    @IBOutlet weak var participatingProjectLabel: UILabel!
    @IBOutlet weak var recruitmentProjectLabel: UILabel!
    @IBOutlet weak var likedLabel: UILabel!
    var cancellables = Set<AnyCancellable>()

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setProjectLabels(nowProject: Int, recruit: Int, liked: Int) {
        participatingProjectLabel.text = "\(nowProject)"
        recruitmentProjectLabel.text = "\(recruit)"
        likedLabel.text = "\(liked)"
    }

}
