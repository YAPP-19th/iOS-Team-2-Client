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
        configureTabBar()
        configureCollectionView()
        bottomView.layer.addBorderTop()

        bottomSheetCollectionView.backgroundColor = .systemGroupedBackground
    }

    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
}

private extension HomeDetailViewController {
    func configureCollectionView() {
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        mainCollectionView.register(.init(nibName: HomeDetailMainCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailMainCollectionViewCell.identifier)
        mainCollectionView.register(.init(nibName: HomeDetailStateCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailStateCollectionViewCell.identifier)
        mainCollectionView.register(.init(nibName: HomeDetailIntroCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailIntroCollectionViewCell.identifier)
        mainCollectionView.register(.init(nibName: HomeDetailLeaderCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailLeaderCollectionViewCell.identifier)
        mainCollectionView.register(.init(nibName: HomeDetailMemberCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailMemberCollectionViewCell.identifier)

        bottomSheetCollectionView.register(.init(nibName: BottomSheetCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: BottomSheetCollectionViewCell.identifier)
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
            case 0: cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailMainCollectionViewCell.identifier, for: indexPath) as UICollectionViewCell
            case 1: cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailStateCollectionViewCell.identifier, for: indexPath) as UICollectionViewCell
            case 2: cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailIntroCollectionViewCell.identifier, for: indexPath) as UICollectionViewCell
            case 3: cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailLeaderCollectionViewCell.identifier, for: indexPath) as UICollectionViewCell
            case 4: cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailMemberCollectionViewCell.identifier, for: indexPath) as UICollectionViewCell
            default: break
            }
        }

        if collectionView == bottomSheetCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomSheetCollectionViewCell.identifier, for: indexPath) as UICollectionViewCell
            cell.backgroundColor = .systemGreen
        }

        return cell
    }
}

extension HomeDetailViewController: UICollectionViewDelegate {

}

extension HomeDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: view.frame.width, height: 0)

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

    func configureTabBar() {
        tabBarController?.tabBar.isHidden = true
    }
}

private extension HomeDetailViewController {
    @objc func actionButtonTapped() {
        let alert = GreetingAlertViewController()
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        present(alert, animated: true, completion: nil)
    }

    func heartButtonTapped() {
        let green = UIColor(named: "Green") ?? .systemGreen
        let gray = UIColor(named: "Gray") ?? .systemGreen

        isHeartButtonChecked.toggle()
        heartButton.setImage(UIImage(systemName: isHeartButtonChecked ? "heart.fill" : "heart"), for: .normal)
        heartButton.tintColor = isHeartButtonChecked ? green : gray
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
