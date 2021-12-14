//
//  HomeWritingPartCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/02.
//

import UIKit
import Combine
import CombineCocoa

protocol HomeWritingPartCellDelegate: AnyObject {
    func showWritingPartBottomView()
}

final class HomeWritingPartCell: UICollectionViewCell {
    
    @IBOutlet private weak var selectPartButton: UIButton!
    
    weak var delegate: HomeWritingPartCellDelegate?
    private var cancellables = Set<AnyCancellable>()

    override func awakeFromNib() {
        super.awakeFromNib()
        setPublisher()
    }
}

private extension HomeWritingPartCell {
    func setPublisher() {
        selectPartButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.showWritingPartBottomView()
            }.store(in: &cancellables)
    }
}
