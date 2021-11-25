//
//  BottomSheetCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit
import Combine
import CombineCocoa

class BottomSheetCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var circleContainerView: UIView!
    @IBOutlet weak var circleView: UIView!

    private var isChecked: Bool = false

    private var cancellables = Set<AnyCancellable>()

    override func awakeFromNib() {
        super.awakeFromNib()
        setPublisher()
    }

    func updateUI(status: RecruitingStatusResponse) {
        textLabel.text = status.positionName
    }
}

private extension BottomSheetCell {
    func setPublisher() {
        containerButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.isChecked.toggle()
                self.containerView.borderColor = self.isChecked ? UIColor.budiGreen : UIColor.budiLightGray
                self.circleContainerView.borderColor = self.isChecked ? UIColor.budiLightGreen : UIColor.budiLightGray
                self.circleView.backgroundColor = self.isChecked ? UIColor.budiGreen : .white
            }.store(in: &cancellables)
    }
}
