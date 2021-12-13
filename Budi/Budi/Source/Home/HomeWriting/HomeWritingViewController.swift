//
//  HomeWritingViewController.swift
//  Budi
//
//  Created by 이상희 on 2021/10/11.
//

import UIKit
import Combine
import CombineCocoa

final class HomeWritingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCollectionView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
}

private extension HomeWritingViewController {
    func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        for cell in HomeWritingCellType.allCases {
            collectionView.register(.init(nibName: cell.type.identifier, bundle: nil), forCellWithReuseIdentifier: cell.type.identifier)
        }
    }
}

extension HomeWritingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        
        switch indexPath.row {
        case 0: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingImageCell.identifier, for: indexPath) as? HomeWritingImageCell else { return cell }
            return cell
        case 1: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingNameCell.identifier, for: indexPath) as? HomeWritingNameCell else { return cell }
            return cell
        case 2: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingPartCell.identifier, for: indexPath) as? HomeWritingPartCell else { return cell }
            return cell
        case 3: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingDurationCell.identifier, for: indexPath) as? HomeWritingDurationCell else { return cell }
            return cell
        case 4: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingOnlineCell.identifier, for: indexPath) as? HomeWritingOnlineCell else { return cell }
            return cell
        case 5: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingAreaCell.identifier, for: indexPath) as? HomeWritingAreaCell else { return cell }
            return cell
        case 6: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingMembersCell.identifier, for: indexPath) as? HomeWritingMembersCell else { return cell }
            return cell
        case 7: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingDescriptionCell.identifier, for: indexPath) as? HomeWritingDescriptionCell else { return cell }
            return cell
        default: break
        }
        
        return cell
    }
}
extension HomeWritingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellType = HomeWritingCellType(rawValue: indexPath.row)
        let size = CGSize(width: collectionView.frame.width, height: cellType?.height ?? 0)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        4
    }
}

private extension HomeWritingViewController {
    func configureNavigationBar() {
        title = "팀원 모집"
        tabBarController?.tabBar.isHidden = true
    }
}
