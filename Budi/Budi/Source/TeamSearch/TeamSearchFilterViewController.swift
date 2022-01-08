//
//  TeamSearchFilterViewController.swift
//  Budi
//
//  Created by 최동규 on 2022/01/05.
//

import UIKit

final class TeamSearchFilterViewController: UIViewController {
    private let collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumLineSpacing = 8
        collectionViewLayout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.backgroundColor = .systemBlue
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .budiWhite
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(.init(nibName: TeamSearchPostionFilterHeader.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TeamSearchPostionFilterHeader.identifier)
        collectionView.register(.init(nibName: TeamSearchDetailCell.identifier, bundle: nil), forCellWithReuseIdentifier: TeamSearchDetailCell.identifier)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        configureNavigationBar()

    }

    func configureNavigationBar() {
        
    }
}

extension TeamSearchFilterViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        15
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TeamSearchPostionFilterHeader.identifier, for: indexPath) as? TeamSearchPostionFilterHeader else { return UICollectionReusableView() }
        return header
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamSearchDetailCell.identifier, for: indexPath) as? TeamSearchDetailCell else { return UICollectionViewCell() }
        cell.postionLabel.superview?.backgroundColor = .init(hexString: "#E7F1FB")
        cell.postionLabel.textColor = .init(hexString: "#3382E0")
        return cell
    }
}

extension TeamSearchFilterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width.nextDown - 40) / 2
        let height = width * (178.0 / 167.5)
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 16, bottom: 8, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.bounds.width, height: 154)
    }
}
