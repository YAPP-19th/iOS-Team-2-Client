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
    }
}

private extension ChattingDetailViewController {
    func configureCollectionView() {
        collecitonView.dataSource = self
        collecitonView.delegate = self
        collecitonView.register(.init(nibName: ChattingDetailCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ChattingDetailCollectionViewCell.identifier)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChattingDetailCollectionViewCell.identifier, for: indexPath) as UICollectionViewCell
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
        8
    }
}

private extension ChattingDetailViewController {
    func configureNavigationBar() {
        let ellipsisButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: nil)
        ellipsisButton.tintColor = .black

        navigationItem.rightBarButtonItem = ellipsisButton
        title = "킬러베어"
    }
}
