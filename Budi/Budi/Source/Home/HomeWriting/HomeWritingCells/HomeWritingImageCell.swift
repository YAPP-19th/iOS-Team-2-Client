//
//  HomeWritingImageCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/02.
//

import UIKit
import Combine
import CombineCocoa

protocol HomeWritingImageCellDelegate: AnyObject {
    func showWritingImageBottomView()
}

final class HomeWritingImageCell: UICollectionViewCell {

    @IBOutlet private weak var imageChangeButton: UIButton!
    
    weak var delegate: HomeWritingImageCellDelegate?
    private var cancellables = Set<AnyCancellable>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setPublisher()
    }
}

private extension HomeWritingImageCell {
    func setPublisher() {
        imageChangeButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.delegate?.showWritingImageBottomView()
            }.store(in: &cancellables)
    }
}
