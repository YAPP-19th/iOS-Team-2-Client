//
//  HomeDetailViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/02.
//

import UIKit

final class HomeDetailViewController: UIViewController {

    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var bottomSheetView: UIView!
    @IBOutlet weak var bottomSheetCollectionView: UICollectionView!

    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var heartCountLabel: UILabel!

    @IBAction func heartButtonTapped(_ sender: Any) {
        heartButtonTapped()
    }
    @IBAction func submitButtonTapped(_ sender: Any) {
        submitButtonTapped()
    }
    @IBAction func bottomSheetCloseButtonTapped(_ sender: Any) {
        bottomSheetCloseButtonTapped()
    }

    weak var coordinator: HomeCoordinator?
    private var isHeartButtonChecked: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCollectionView()
        bottomView.layer.addBorderTop()
    }

    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.setTranslucent()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.removeTranslucent()
    }
}

private extension HomeDetailViewController {
    func configureCollectionView() {
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        mainCollectionView.register(.init(nibName: HomeDetailMainCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailMainCell.identifier)
        mainCollectionView.register(.init(nibName: HomeDetailStateCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailStateCell.identifier)
        mainCollectionView.register(.init(nibName: HomeDetailIntroCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailIntroCell.identifier)
        mainCollectionView.register(.init(nibName: HomeDetailLeaderCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailLeaderCell.identifier)
        mainCollectionView.register(.init(nibName: HomeDetailMemberCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailMemberCell.identifier)

        bottomSheetCollectionView.dataSource = self
        bottomSheetCollectionView.delegate = self
        bottomSheetCollectionView.register(.init(nibName: BottomSheetCell.identifier, bundle: nil), forCellWithReuseIdentifier: BottomSheetCell.identifier)

    }
}

extension HomeDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case mainCollectionView: return 5
        case bottomSheetCollectionView: return 4
        default: return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()

        if collectionView == mainCollectionView {
            switch indexPath.row {
            case 0: cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailMainCell.identifier, for: indexPath) as UICollectionViewCell
            case 1: cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailStateCell.identifier, for: indexPath) as UICollectionViewCell
            case 2: cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailIntroCell.identifier, for: indexPath) as UICollectionViewCell
            case 3: cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailLeaderCell.identifier, for: indexPath) as UICollectionViewCell
            case 4: cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailMemberCell.identifier, for: indexPath) as UICollectionViewCell
            default: break
            }
        }

        if collectionView == bottomSheetCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomSheetCell.identifier, for: indexPath) as UICollectionViewCell
        }

        return cell
    }
}

extension HomeDetailViewController: UICollectionViewDelegate {

}

extension HomeDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var size = CGSize(width: collectionView.frame.width, height: 0)

        if collectionView == mainCollectionView {
            switch indexPath.row {
            case 0: size.height = 436
            case 1: size.height = 181
            case 2: size.height = 578
            case 3: size.height = 176
            case 4: size.height = 344
            default: break
            }
        }

        if collectionView == bottomSheetCollectionView {
            size.height = 56
        }

        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case mainCollectionView: return 0
        case bottomSheetCollectionView: return 8
        default: return 0
        }
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
    @objc
    func actionButtonTapped() {
        let alert = GreetingAlertViewController()
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        present(alert, animated: true, completion: nil)
    }

    func heartButtonTapped() {
        isHeartButtonChecked.toggle()
        heartButton.setImage(UIImage(systemName: isHeartButtonChecked ? "heart.fill" : "heart"), for: .normal)
        heartButton.tintColor = isHeartButtonChecked ? UIColor.budiGreen : UIColor.budiGray
    }

    func submitButtonTapped() {
        backgroundView.isHidden = false

        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.bottomSheetView.center.y -= self?.bottomSheetView.bounds.height ?? 0
        }, completion: nil)
    }

    func bottomSheetCloseButtonTapped() {
        backgroundView.isHidden = true

        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.bottomSheetView.center.y += self?.bottomSheetView.bounds.height ?? 0
        }, completion: nil)
    }
}
