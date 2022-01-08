//
//  TeamSearchPostionFilterHeader.swift
//  Budi
//
//  Created by 최동규 on 2022/01/05.
//

import UIKit

final class TeamSearchPostionFilterHeader: UICollectionReusableView {

    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
        // Initialization code
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
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        15
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PositionLabelCell.identifier, for: indexPath) as? PositionLabelCell else { return UICollectionViewCell() }
        cell.backgroundColor = .init(hexString: "#E7F1FB")
        cell.label.textColor = .init(hexString: "#3382E0")
        cell.label.text = "dochoi"
//        cell.updateUI(viewModel.state.sections.value[indexPath.section].postion)
        return cell
    }
}

extension TeamSearchPostionFilterHeader: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = "dochoi"
        label.sizeToFit()
        label.layoutIfNeeded()
        return .init(width: label.frame.width + 24, height: 25)
    }
}
