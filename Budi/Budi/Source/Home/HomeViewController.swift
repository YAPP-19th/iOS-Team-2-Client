//
//  HomeViewController.swift
//  Budi
//
//  Created by 최동규 on 2021/10/11.
//

import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    weak var coordinator: HomeCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()

        collectionView.collectionViewLayout = createLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(.init(nibName: HomeCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        view.backgroundColor = .white
    }

    @IBAction func writeButtonDidTouchUpInside(_ sender: UIButton) {
        coordinator?.showWriting()
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as UICollectionViewCell
        cell.backgroundColor = .systemGroupedBackground
        cell.layer.cornerRadius = 12
        cell.borderColor = .systemGray4
        cell.borderWidth = 1
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.showDetail()
    }
}

extension HomeViewController: UICollectionViewDelegate {

}

private extension HomeViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(263 / 343)))
            item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 0)

            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100)), subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 27, leading: 16, bottom: 0, trailing: 16)
            return section
        }
    }

    func configureNavigationBar() {
        let editButton = UIButton()
        editButton.setImage(.init(systemName: "line.3.horizontal"), for: .normal)

        let searchButton = UIButton()
        searchButton.setImage(.init(systemName: "magnifyingglass"), for: .normal)

        let notifyButton = UIButton()
        notifyButton.setImage(.init(systemName: "bell"), for: .normal)

        let stackview = UIStackView(arrangedSubviews: [editButton, searchButton, notifyButton])
        stackview.distribution = .equalSpacing
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 8

        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: stackview)
        title = "버디 모집"
    }
}
