//
//  BottomSheetViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit

class BottomSheetViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func cancelButtonTapped(_ sender: Any) {
        cancelButtonTapped()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
}

private extension BottomSheetViewController {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomSheetCollectionViewCell.identifier, for: indexPath) as UICollectionViewCell
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
        dismiss(animated: true, completion: nil)
    }
}
