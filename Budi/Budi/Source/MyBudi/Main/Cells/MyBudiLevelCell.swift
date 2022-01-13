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
    var cancellables = Set<AnyCancellable>()
    @IBOutlet weak var levelSlider: CustomSlider!
    override func prepareForReuse() {
        super.prepareForReuse()
        configureLayout()
        cancellables.removeAll()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }

    private func configureLayout() {
        let thumbImage = UIImage(named: "Slider_Dev_Lv2")
        levelSlider.setThumbImage(thumbImage, for: .normal)
        levelSlider.setThumbImage(thumbImage, for: .selected)
        levelSlider.cornerRadius = 8
        
    }

    func setLevel(level: String, position: Int) {
        var levelImage: String = ""

        switch position {
        case 1:
            levelImage += "Slider_Dev_"
        case 2:
            levelImage += "Slider_Design_"
        case 3:
            levelImage += "Slider_Plan_"
        default:
            break
        }

        switch level {
        case _ where level.contains("씨앗"):
            levelImage += "Lv1"
        case _ where level.contains("새싹"):
            levelImage += "Lv2"
        case _ where level.contains("꽃잎"):
            levelImage += "Lv3"
        case _ where level.contains("열매"):
            levelImage += "Lv4"
        default:
            levelImage += "Lv4"
        }

        switch level {
        case _ where level.contains("씨앗"):
            levelSlider.value = 0
        case _ where level.contains("새싹"):
            levelSlider.value = 0.33
        case _ where level.contains("꽃잎"):
            levelSlider.value = 0.66
        case _ where level.contains("열매"):
            levelSlider.value = 1.0
        default:
            levelSlider.value = 1.0
        }
        levelSlider.setThumbImage(UIImage(named: levelImage), for: .normal)
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
