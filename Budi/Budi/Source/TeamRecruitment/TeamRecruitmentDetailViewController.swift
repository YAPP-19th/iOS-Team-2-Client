//
//  TeamRecruitmentDetailViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/02.
//

import UIKit

final class TeamRecruitmentDetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    weak var coordinator: TeamRecruitmentCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()

        collectionView.collectionViewLayout = createLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(.init(nibName: TeamRecruitmentDetailCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TeamRecruitmentDetailCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
    }
}

extension TeamRecruitmentDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamRecruitmentDetailCollectionViewCell.identifier, for: indexPath) as UICollectionViewCell
        cell.backgroundColor = .systemGroupedBackground
        return cell
    }
}

extension TeamRecruitmentDetailViewController: UICollectionViewDelegate {

}

private extension TeamRecruitmentDetailViewController {
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
        navigationItem.rightBarButtonItem = .init(systemItem: .done)
    }
}
