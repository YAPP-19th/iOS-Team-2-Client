//
//  ChattingDetailViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit

class ChattingDetailViewController: UIViewController {

    @IBOutlet weak var collecitonView: UICollectionView!
    weak var coordinator: ChattingCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCollectionView()
        configureTabBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
}

private extension ChattingDetailViewController {
    func configureCollectionView() {
        collecitonView.dataSource = self
        collecitonView.delegate = self
        collecitonView.register(.init(nibName: MessageCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: MessageCollectionViewCell.identifier)
        collecitonView.register(.init(nibName: MyMessageCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: MyMessageCollectionViewCell.identifier)
        collecitonView.backgroundColor = .systemGroupedBackground
    }
}

extension ChattingDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row % 2 == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCollectionViewCell.identifier, for: indexPath) as UICollectionViewCell
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyMessageCollectionViewCell.identifier, for: indexPath) as UICollectionViewCell
        return cell
    }
}

extension ChattingDetailViewController: UICollectionViewDelegate {

}

extension ChattingDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        24
    }
}

private extension ChattingDetailViewController {
    func configureNavigationBar() {
        let ellipsisButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: nil)
        ellipsisButton.tintColor = .black

        navigationItem.rightBarButtonItem = ellipsisButton
        title = "킬러베어"
    }
    
    func configureTabBar() {
        tabBarController?.tabBar.isHidden = true
    }
}
