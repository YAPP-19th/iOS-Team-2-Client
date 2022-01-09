//
//  MyBudiLevelCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/21.
//

import UIKit
import Combine
import CombineCocoa

final class MyBudiLevelCell: UICollectionViewCell {

    @IBOutlet weak var levelSlider: CustomSlider!
    override func prepareForReuse() {
        super.prepareForReuse()
        configureLayout()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }

    private func configureLayout() {
        let thumbImage = UIImage(named: "Dev_Lv2")
        levelSlider.setThumbImage(thumbImage, for: .normal)
        levelSlider.setThumbImage(thumbImage, for: .selected)
    }

    func setLevel(level: String) {
        
    }

    private func thumbImage() -> UIImage {
        let thumbView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        thumbView.backgroundColor = .clear
        let render = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return render.image { context in
            thumbView.layer.render(in: context.cgContext)

        }
    }
}
