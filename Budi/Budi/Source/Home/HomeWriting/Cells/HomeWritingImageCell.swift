//
//  HomeWritingImageCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/02.
//

import UIKit
import Combine
import CombineCocoa

final class HomeWritingImageCell: UICollectionViewCell {

    @IBOutlet weak var imageChangeButton: UIButton!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bindViewModel()
        setPublisher()
    }
}

private extension HomeWritingImageCell {
    func bindViewModel() {
    }
    
    func setPublisher() {
        imageChangeButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
            }.store(in: &cancellables)
    }
}
