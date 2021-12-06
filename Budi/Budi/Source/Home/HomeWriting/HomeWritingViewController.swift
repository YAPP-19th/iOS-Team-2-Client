//
//  HomeWritingViewController.swift
//  Budi
//
//  Created by 최동규 on 2021/10/11.
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
}

private extension HomeWritingViewController {
    func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(.init(nibName: HomeWritingImageCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeWritingImageCell.identifier)
        collectionView.register(.init(nibName: HomeWritingNameCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeWritingNameCell.identifier)
        collectionView.register(.init(nibName: HomeWritingPartCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeWritingPartCell.identifier)
        collectionView.register(.init(nibName: HomeWritingDurationCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeWritingDurationCell.identifier)
        collectionView.register(.init(nibName: HomeWritingOnlineCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeWritingOnlineCell.identifier)
        collectionView.register(.init(nibName: HomeWritingAreaCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeWritingAreaCell.identifier)
        collectionView.register(.init(nibName: HomeWritingMembersCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeWritingMembersCell.identifier)
        collectionView.register(.init(nibName: HomeWritingDescriptionCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeWritingDescriptionCell.identifier)
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
        var size = CGSize(width: collectionView.frame.width, height: 0)
        
        switch indexPath.row {
        case 0: size.height = 280 // Image
        case 1: size.height = 109 // Name
        case 2: size.height = 117 // Part
        case 3: size.height = 109 // Duration
        case 4: size.height = 117 // Online
        case 5: size.height = 117 // Area
        case 6: size.height = 117 // Members
        case 7: size.height = 387 + 64 // Description
        default: break
        }
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        4
    }
}

private extension HomeWritingViewController {
    func configureNavigationBar() {
        title = "팀원 모집"
    }
}
