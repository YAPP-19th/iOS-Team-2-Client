//
//  TeamSearchPostionFilterHeader.swift
//  Budi
//
//  Created by 최동규 on 2022/01/05.
//

import UIKit
import Combine
import CombineCocoa
import Moya

final class TeamSearchPostionFilterHeader: UICollectionReusableView {

    @IBOutlet weak var collectionView: UICollectionView!
    private let provider = MoyaProvider<BudiTarget>()
    private var positions: [String] = []
    private var cancellables = Set<AnyCancellable>()

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func fetch(position: Position) {
        self.provider
            .requestPublisher(.detailPositions(position: position))
            .map(APIResponse<[String]>.self)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] positions in
                self?.positions = positions
                self?.collectionView.reloadData()
            })
            .store(in: &self.cancellables)
    }
}

private extension TeamSearchPostionFilterHeader {
    func configure() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowLayout
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.register(.init(nibName: PositionLabelCell.identifier, bundle: nil), forCellWithReuseIdentifier: PositionLabelCell.identifier)
    }
    
}

extension TeamSearchPostionFilterHeader: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return positions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PositionLabelCell.identifier, for: indexPath) as? PositionLabelCell else { return UICollectionViewCell() }
        let position = positions[indexPath.item]
        cell.backgroundColor = .clear
        cell.layer.borderColor = UIColor.budiGray.cgColor
        cell.layer.borderWidth = 1
        cell.label.text = position
        return cell
    }
}

extension TeamSearchPostionFilterHeader: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = positions[indexPath.item]
        label.sizeToFit()
        label.layoutIfNeeded()
        return .init(width: label.frame.width + 24, height: 32)
    }
}
