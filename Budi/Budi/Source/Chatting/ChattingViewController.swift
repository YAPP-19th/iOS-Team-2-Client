//
//  ChattingViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit

class ChattingViewController: UIViewController {

    @IBOutlet weak var collecitonView: UICollectionView!
    weak var coordinator: ChattingCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCollectionView()
    }
}

private extension ChattingViewController {
    func configureCollectionView() {
        collecitonView.dataSource = self
        collecitonView.delegate = self
        collecitonView.register(.init(nibName: ChattingCell.identifier, bundle: nil), forCellWithReuseIdentifier: ChattingCell.identifier)
        collecitonView.backgroundColor = .systemGroupedBackground
    }
}

extension ChattingViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChattingCell.identifier, for: indexPath) as UICollectionViewCell
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.showDetail()
    }
}

extension ChattingViewController: UICollectionViewDelegate {

}

extension ChattingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 97)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
}

private extension ChattingViewController {
    func configureNavigationBar() {
        let notifyButton = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: nil)
        notifyButton.tintColor = .black

        navigationItem.rightBarButtonItem = notifyButton
        title = "채팅"
    }
}
