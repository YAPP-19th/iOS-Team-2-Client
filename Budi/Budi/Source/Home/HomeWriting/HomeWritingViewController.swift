//
//  HomeWritingViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/10/11.
//

import UIKit
import Combine
import CombineCocoa

final class HomeWritingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var coordinator: HomeCoordinator?
    private let viewModel: HomeWritingViewModel
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    init?(coder: NSCoder, viewModel: HomeWritingViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("This viewController must be init with viewModel")
    }
}

private extension HomeWritingViewController {
    func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        HomeWritingCellType.allCases.forEach {
            collectionView.register(.init(nibName: $0.type.identifier, bundle: nil), forCellWithReuseIdentifier: $0.type.identifier)
        }
    }
}

extension HomeWritingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        HomeWritingCellType.getCell(collectionView, indexPath)
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
