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

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(.init(nibName: HomeDetailMainCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailMainCollectionViewCell.identifier)
        collectionView.register(.init(nibName: HomeDetailStateCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailStateCollectionViewCell.identifier)
        collectionView.register(.init(nibName: HomeDetailIntroCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailIntroCollectionViewCell.identifier)
        collectionView.register(.init(nibName: HomeDetailLeaderCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailLeaderCollectionViewCell.identifier)
        collectionView.register(.init(nibName: HomeDetailMemberCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailMemberCollectionViewCell.identifier)
        collectionView.register(.init(nibName: DividerCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: DividerCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
    }
}

extension HomeDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()

        switch indexPath.row {
        case 0: cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailMainCollectionViewCell.identifier, for: indexPath) as UICollectionViewCell
        case 1: cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailStateCollectionViewCell.identifier, for: indexPath) as UICollectionViewCell
        case 2: cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailIntroCollectionViewCell.identifier, for: indexPath) as UICollectionViewCell
        case 3: cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailLeaderCollectionViewCell.identifier, for: indexPath) as UICollectionViewCell
        case 4: cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailMemberCollectionViewCell.identifier, for: indexPath) as UICollectionViewCell
        default: break
        }

        return cell
    }
}

extension HomeDetailViewController: UICollectionViewDelegate {

}

extension HomeDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0: return CGSize(width: view.frame.width, height: 436)
        case 1: return CGSize(width: view.frame.width, height: 181)
        case 2: return CGSize(width: view.frame.width, height: 578)
        case 3: return CGSize(width: view.frame.width, height: 176)
        case 4: return CGSize(width: view.frame.width, height: 374)
        default: break
        }

        return CGSize.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

private extension HomeDetailViewController {
    func configureNavigationBar() {
        let actionButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonTapped))
        navigationItem.rightBarButtonItem = actionButton
        navigationController?.navigationBar.tintColor = .systemGray
    }
}

private extension HomeDetailViewController {
    @objc func actionButtonTapped() {
        print("actionButtonTapped")
    }
}
