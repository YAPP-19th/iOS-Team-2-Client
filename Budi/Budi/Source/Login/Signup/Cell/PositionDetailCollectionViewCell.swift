//
//  PositionDetailCollectionViewCell.swift
//  Budi
//
//  Created by 인병윤 on 2021/12/12.
//

import UIKit
import Combine
import CombineCocoa

class PositionDetailCollectionViewCell: UICollectionViewCell {
    static let cellId = "positionDetailCell"
    private var cancellables = Set<AnyCancellable>()

    let positionDetailButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.init(white: 0.2, alpha: 0.4).cgColor
        button.layer.cornerRadius = 5
        button.setTitleColor(UIColor.init(white: 0.4, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.clipsToBounds = true
        return button
    }()

    let leftEmptyView = UIView()
    let rightEmptyView = UIView()

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        //buttonBind()

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLayout()
        //buttonBind()
    }

    func configureButtonText(_ text: String) {
        positionDetailButton.setTitle(text, for: .normal)
    }

    private func configureLayout() {
        addSubview(positionDetailButton)
        positionDetailButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            positionDetailButton.topAnchor.constraint(equalTo: self.topAnchor),
            positionDetailButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            positionDetailButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            positionDetailButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
