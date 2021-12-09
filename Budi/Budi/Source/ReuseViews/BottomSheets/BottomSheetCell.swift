//
//  BottomSheetCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit
import Combine
import CombineCocoa

protocol BottomSheetCellDelegate: AnyObject {
    func selectBottomSheetCell(_ recruitingStatus: RecruitingStatus)
}

class BottomSheetCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var circleContainerView: UIView!
    @IBOutlet weak var circleView: UIView!

    var isChecked: Bool = false
    var recruitingStatus: RecruitingStatus? {
        didSet {
            textLabel.text = recruitingStatus?.positionName
        }
    }
    
    weak var delegate: BottomSheetCellDelegate?

    private var cancellables = Set<AnyCancellable>()

    override func awakeFromNib() {
        super.awakeFromNib()
        setPublisher()
    }
}

private extension BottomSheetCell {
    func setPublisher() {
        containerButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                if let recruitingStatus = self.recruitingStatus {
                    self.isChecked.toggle()
                    self.configureUI()
                    self.delegate?.selectBottomSheetCell(recruitingStatus)
                }
            }.store(in: &cancellables)
    }
    
    func configureUI() {
        containerView.borderColor = isChecked ? .budiGreen : .budiLightGray
        circleContainerView.borderColor = isChecked ? .budiLightGreen : .budiLightGray
        circleView.backgroundColor = isChecked ? .budiGreen : .white
    }
}
