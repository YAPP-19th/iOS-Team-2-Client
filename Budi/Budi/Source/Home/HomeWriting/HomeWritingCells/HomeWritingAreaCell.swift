//
//  HomeWritingAreaCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/02.
//

import UIKit
import Combine
import CombineCocoa

protocol HomeWritingAreaCellDelegate: AnyObject {
    func showLocationSearchViewController()
}

final class HomeWritingAreaCell: UICollectionViewCell {
    
    @IBOutlet private weak var areaTextField: UITextField!
    @IBOutlet private weak var selectButton: UIButton!
    
    weak var delegate: HomeWritingAreaCellDelegate?
    private var cancellables = Set<AnyCancellable>()

    override func awakeFromNib() {
        super.awakeFromNib()
        setPublisher()
    }
}

private extension HomeWritingAreaCell {
    func setPublisher() {
        selectButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.showLocationSearchViewController()
                self.configureUI()
            }.store(in: &cancellables)
    }
    
    func configureUI() {
    }
}
