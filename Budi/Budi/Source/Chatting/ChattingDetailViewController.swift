//
//  ChattingDetailViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit

class ChattingDetailViewController: UIViewController {

    @IBOutlet weak var collecitonView: UICollectionView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var textField: UITextField!

    @IBAction func textFieldTapped(_ sender: Any) {
    }
    @IBAction func smileButtonTapped(_ sender: Any) {
    }
    @IBAction func sendButtonTapped(_ sender: Any) {
    }

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
        collecitonView.register(.init(nibName: ChattingMessageCell.identifier, bundle: nil), forCellWithReuseIdentifier: ChattingMessageCell.identifier)
        collecitonView.register(.init(nibName: MyChattingMessageCell.identifier, bundle: nil), forCellWithReuseIdentifier: MyChattingMessageCell.identifier)
        collecitonView.register(.init(nibName: ChattingTimeCell.identifier, bundle: nil), forCellWithReuseIdentifier: ChattingTimeCell.identifier)
        collecitonView.alwaysBounceVertical = true
        collecitonView.backgroundColor = .systemGroupedBackground
    }
}

extension ChattingDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChattingTimeCell.identifier, for: indexPath) as UICollectionViewCell
            return cell
        } else if indexPath.row % 2 == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChattingMessageCell.identifier, for: indexPath) as UICollectionViewCell
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyChattingMessageCell.identifier, for: indexPath) as UICollectionViewCell
        return cell
    }
}

extension ChattingDetailViewController: UICollectionViewDelegate {

}

extension ChattingDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: collectionView.frame.width, height: 40)
        }
        return CGSize(width: collectionView.frame.width, height: 100)
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
