//
//  BottomSheetViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit

class BottomSheetViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func cancelButtonTapped(_ sender: Any) {
        cancelButtonTapped()
    }
    
    private let jobGroups = ["iOS 개발자", "서버 개발자", "디자이너", "기획자"]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureContainerView()
        configureCollectionView()
    }
}

private extension BottomSheetViewController {
    func configureContainerView() {
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseInOut) { [weak self] in
            self?.containerView.center.y -= self?.containerView.bounds.height ?? 0
        } completion: { _ in
        }
    }

    func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(.init(nibName: BottomSheetCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: BottomSheetCollectionViewCell.identifier)
    }
}

extension BottomSheetViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomSheetCollectionViewCell.identifier, for: indexPath) as? BottomSheetCollectionViewCell else { return UICollectionViewCell() }
        cell.jobGroup = jobGroups[indexPath.row]
        return cell
    }
}

extension BottomSheetViewController: UICollectionViewDelegate {

}

extension BottomSheetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 56)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}

private extension BottomSheetViewController {
    func cancelButtonTapped() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
