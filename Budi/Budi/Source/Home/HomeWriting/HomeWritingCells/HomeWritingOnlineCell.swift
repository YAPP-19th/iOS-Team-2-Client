//
//  HomeWritingOnlineCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/02.
//

import UIKit

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
    
    @IBAction private func onlineContainerButtonTapped(_ sender: Any) {
        delegate?.changeOnline(true)
        isOnlineChecked = true
        configureUI()
    }
    @IBAction private func offlineContainerButtonTapped(_ sender: Any) {
        delegate?.changeOnline(false)
        isOnlineChecked = false
        configureUI()
    }
    
    var isOnlineChecked: Bool = true
    
    weak var delegate: HomeWritingOnlineCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func configureUI() {
        onlineCircleContainerView.borderColor = isOnlineChecked ? .border : .border
        onlineCircleView.backgroundColor = isOnlineChecked ? .primary : .white
        
        offlineCircleContainerView.borderColor = !isOnlineChecked ? .border : .border
        offlineCircleView.backgroundColor = !isOnlineChecked ? .primary : .white
    }
}
