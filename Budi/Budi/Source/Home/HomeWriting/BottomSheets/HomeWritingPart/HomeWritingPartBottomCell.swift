//
//  HomeWritingPartBottomCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/14.
//

import UIKit
import Combine
import CombineCocoa

protocol HomeWritingPartBottomCellDelegate: AnyObject {
    func selectPart()
}

final class HomeWritingPartBottomCell: UICollectionViewCell {

    @IBOutlet private weak var containerButton: UIButton!
    @IBOutlet private weak var circleContainerView: UIView!
    @IBOutlet private weak var circleView: UIView!
    @IBOutlet private weak var partLabel: UILabel!
    
    private var isChecked: Bool = false
    
    weak var delegate: HomeWritingPartBottomCellDelegate?
    private var cancellables = Set<AnyCancellable>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setPublisher()
    }
}

private extension HomeWritingPartBottomCell {
    func setPublisher() {
        containerButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.isChecked.toggle()
                self.configureUI()
            }.store(in: &cancellables)
    }
    
    func configureUI() {
        circleContainerView.borderColor = isChecked ? .budiLightGreen : .budiLightGray
        circleView.backgroundColor = isChecked ? .budiGreen : .white
    }
}
