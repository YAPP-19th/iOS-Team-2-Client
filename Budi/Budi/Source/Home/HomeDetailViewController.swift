//
//  HomeDetailViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/02.
//

import UIKit

final class HomeDetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    weak var coordinator: HomeCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()

        collectionView.collectionViewLayout = createLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(.init(nibName: HomeDetailCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
    }
}

extension HomeDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailCollectionViewCell.identifier, for: indexPath) as UICollectionViewCell
        cell.backgroundColor = .systemGroupedBackground
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.section)
    }
}

extension HomeDetailViewController: UICollectionViewDelegate {

}

private extension HomeDetailViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5)))
            item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 0)

            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100)), subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
            return section
        }
    }

    func configureNavigationBar() {
        let actionButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonTapped))
        navigationItem.rightBarButtonItem = actionButton
        navigationController?.navigationBar.tintColor = .white
    }
}

private extension HomeDetailViewController {
    @objc func actionButtonTapped() {
        print("actionButtonTapped")
    }
}
