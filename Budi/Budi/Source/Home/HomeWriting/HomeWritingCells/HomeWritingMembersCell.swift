//
//  HomeWritingMembersCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/02.
//

import UIKit
import Combine
import CombineCocoa

protocol HomeWritingMembersCellDelegate: AnyObject {
    func showWritingMembersBottomView()
}

final class HomeWritingMembersCell: UICollectionViewCell {
    
    @IBOutlet private  weak var addButton: UIButton!
    
    weak var delegate: HomeWritingMembersCellDelegate?
    private var cancellables = Set<AnyCancellable>()

    override func awakeFromNib() {
        super.awakeFromNib()
        setPublisher()
    }
}

private extension HomeWritingMembersCell {
    func setPublisher() {
        addButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.showWritingMembersBottomView()
            }.store(in: &cancellables)
    }
}
