//
//  TeamRecruitmentWritingViewController.swift
//  Budi
//
//  Created by 최동규 on 2021/10/11.
//

import UIKit

final class TeamRecruitmentWritingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()

        collectionView.collectionViewLayout = createLayout()
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(.init(nibName: TeamRecruitmentWritingLocationCell.identifier, bundle: nil), forCellWithReuseIdentifier: TeamRecruitmentWritingLocationCell.identifier)
        collectionView.register(.init(nibName: TeamRecruitmentWritingMemberCell.identifier, bundle: nil), forCellWithReuseIdentifier: TeamRecruitmentWritingMemberCell.identifier)
        collectionView.register(.init(nibName: TeamRecruitmentWritingDescriptionCell.identifier, bundle: nil), forCellWithReuseIdentifier: TeamRecruitmentWritingDescriptionCell.identifier)
        collectionView.register(.init(nibName: TeamRecruitmentWritingPartCell.identifier, bundle: nil), forCellWithReuseIdentifier: TeamRecruitmentWritingPartCell.identifier)
    }
}

extension TeamRecruitmentWritingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamRecruitmentWritingLocationCell.identifier, for: indexPath) as UICollectionViewCell
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamRecruitmentWritingMemberCell.identifier, for: indexPath) as UICollectionViewCell
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamRecruitmentWritingDescriptionCell.identifier, for: indexPath) as UICollectionViewCell
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamRecruitmentWritingPartCell.identifier, for: indexPath) as UICollectionViewCell
            return cell
        }
    }
}

extension TeamRecruitmentWritingViewController: UICollectionViewDelegateFlowLayout {

}

private extension TeamRecruitmentWritingViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let inset: CGFloat = 16

            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.4)))
            item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100)), subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 0, leading: inset, bottom: 0, trailing: inset)
            return section
        }
    }

    func configureNavigationBar() {
        navigationItem.rightBarButtonItem = .init(systemItem: .done)
        title = "팀원 모집"
    }
}
