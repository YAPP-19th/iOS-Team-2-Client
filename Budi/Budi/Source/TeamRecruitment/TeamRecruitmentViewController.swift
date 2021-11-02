//
//  TeamRecrutimentViewController.swift
//  Budi
//
//  Created by 최동규 on 2021/10/11.
//

import UIKit

final class TeamRecruitmentViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    weak var coordinator: TeamRecruitmentCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()

        collectionView.collectionViewLayout = createLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(.init(nibName: TeamRecruitmentCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TeamRecruitmentCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
    }

    @IBAction func writeButtonDidTouchUpInside(_ sender: UIButton) {
        coordinator?.showWriting()
    }
}

extension TeamRecruitmentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamRecruitmentCollectionViewCell.identifier, for: indexPath) as UICollectionViewCell
        cell.backgroundColor = .systemGroupedBackground
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        coordinator?.showDetail()
    }
}

extension TeamRecruitmentViewController: UICollectionViewDelegate {

}

private extension TeamRecruitmentViewController {
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

        navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: stackview)
        title = "버디 모집"
    }
}
