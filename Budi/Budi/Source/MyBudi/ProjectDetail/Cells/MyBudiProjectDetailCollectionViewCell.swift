//
//  MyBudiProjectDetailCollectionViewCell.swift
//  Budi
//
//  Created by 인병윤 on 2022/01/09.
//

import UIKit
import Combine
import CombineCocoa

class MyBudiProjectDetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var projectDateLabel: UILabel!
    @IBOutlet weak var projectImageView: UIImageView!
    @IBOutlet weak var projectMainTitleLabel: UILabel!
    @IBOutlet weak var projectSubTitleLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setProject() {
        
    }
}
