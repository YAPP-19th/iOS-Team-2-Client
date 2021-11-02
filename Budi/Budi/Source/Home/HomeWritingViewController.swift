//
//  HomeWritingViewController.swift
//  Budi
//
//  Created by 최동규 on 2021/10/11.
//

import UIKit

final class HomeWritingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
}

extension HomeWritingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
extension HomeWritingViewController: UICollectionViewDelegateFlowLayout {

}

private extension HomeWritingViewController {
    func configureNavigationBar() {
        navigationItem.rightBarButtonItem = .init(systemItem: .done)
        title = "팀원 모집"
    }
}
