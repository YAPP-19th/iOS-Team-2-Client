//
//  TeamSearchCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit
import Combine

final class TeamSearchCell: UICollectionViewCell {

    @IBOutlet private weak var headerImageView: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var headerTitleLabel: UILabel!
    @IBOutlet weak var headerStackView: UIStackView!
    var cancellables = Set<AnyCancellable>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }

    func updateUI(_ position: Position) {
        headerTitleLabel.text = position.rawValue
        headerImageView.image = position.teamSearchCharacter
    }

}

private extension TeamSearchCell {
    func configure() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8
        collectionView.collectionViewLayout = flowLayout
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.register(.init(nibName: TeamSearchDetailCell.identifier, bundle: nil), forCellWithReuseIdentifier: TeamSearchDetailCell.identifier)
    }
}

extension TeamSearchCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamSearchDetailCell.identifier, for: indexPath) as? TeamSearchDetailCell else { return UICollectionViewCell() }
        cell.postionLabel.superview?.backgroundColor = .init(hexString: "#E7F1FB")
        cell.postionLabel.textColor = .init(hexString: "#3382E0")
//        cell.updateUI(viewModel.state.sections.value[indexPath.section].postion)
        return cell
    }
}

extension TeamSearchCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width.nextDown - 8) / 2
        let height = width * (178.0 / 167.5)
        return CGSize(width: width, height: height)
    }
}

private extension TeamSearchViewController {
    func configureNavigationBar() {
        let searchButton = UIButton()
        searchButton.setImage(.init(systemName: "magnifyingglass"), for: .normal)

        let notifyButton = UIButton()
        notifyButton.setImage(.init(systemName: "bell"), for: .normal)

        let stackview = UIStackView(arrangedSubviews: [searchButton, notifyButton])
        stackview.distribution = .equalSpacing
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 8

        navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: stackview)
        title = "버디 찾기"
    }
}
