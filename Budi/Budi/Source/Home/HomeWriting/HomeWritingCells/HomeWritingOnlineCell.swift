//
//  HomeWritingOnlineCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/02.
//

import UIKit
import Combine
import CombineCocoa

protocol HomeWritingOnlineCellDelegate: AnyObject {
    func changeOnline(_ isOnline: Bool)
}

final class HomeWritingOnlineCell: UICollectionViewCell {

    @IBOutlet private weak var onlineCircleContainerView: UIView!
    @IBOutlet private weak var onlineCircleView: UIView!
    @IBOutlet private weak var offlineCircleContainerView: UIView!
    @IBOutlet private weak var offlineCircleView: UIView!
    
    @IBOutlet private weak var onlineContainerButton: UIButton!
    @IBOutlet private weak var offlineContainerButton: UIButton!
    
    var isOnlineChecked: Bool = true
    
    weak var delegate: HomeWritingOnlineCellDelegate?
    private var cancellables = Set<AnyCancellable>()
    
    override func prepareForReuse() {
        cancellables.removeAll()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setPublisher()
    }
}

private extension HomeWritingOnlineCell {
    func setPublisher() {
        onlineContainerButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.changeOnline(true)
                self.isOnlineChecked = true
                self.configureUI()
            }.store(in: &cancellables)
        
        offlineContainerButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.changeOnline(false)
                self.isOnlineChecked = false
                self.configureUI()
            }.store(in: &cancellables)
    }
    
    func configureUI() {
        onlineCircleContainerView.borderColor = isOnlineChecked ? .border : .border
        onlineCircleView.backgroundColor = isOnlineChecked ? .primary : .white
        
        offlineCircleContainerView.borderColor = !isOnlineChecked ? .border : .border
        offlineCircleView.backgroundColor = !isOnlineChecked ? .primary : .white
    }
}
