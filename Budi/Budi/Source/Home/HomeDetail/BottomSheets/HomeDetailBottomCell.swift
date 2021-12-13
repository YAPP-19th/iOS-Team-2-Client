//
//  HomeDetailBottomSheetCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit
import Combine
import CombineCocoa

protocol HomeDetailBottomCellDelegate: AnyObject {
    func selectBottomSheetCell(_ recruitingStatus: RecruitingStatus)
}

final class HomeDetailBottomCell: UICollectionViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var containerButton: UIButton!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var circleContainerView: UIView!
    @IBOutlet private weak var circleView: UIView!

    private var isChecked: Bool = false
    var recruitingStatus: RecruitingStatus? {
        didSet {
            textLabel.text = recruitingStatus?.positionName
        }
    }
    
    weak var delegate: HomeDetailBottomCellDelegate?
    private var cancellables = Set<AnyCancellable>()

    override func awakeFromNib() {
        super.awakeFromNib()
        setPublisher()
    }
}

private extension HomeDetailBottomCell {
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
