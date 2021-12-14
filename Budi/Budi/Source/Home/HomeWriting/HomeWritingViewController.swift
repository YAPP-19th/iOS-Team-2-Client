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

    @IBOutlet private weak var collectionView: UICollectionView!
    
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
    func configureNavigationBar() {
        title = "팀원 모집"
        tabBarController?.tabBar.isHidden = true
    }
}

// MARK: - Delegate
extension HomeWritingViewController: HomeWritingImageCellDelegate {
    func changeCoverImage() {
        coordinator?.showWritingImageBottomView(self, viewModel)
    }
}

extension HomeWritingViewController: HomeWritingPartCellDelegate {
    func changePart() {
        coordinator?.showWritingPartBottomView(self, viewModel)
    }
}

// MARK: - CollectionView
extension HomeWritingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func configureCollectionView() {
        HomeWritingCellType.configureCollectionView(self, collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        HomeWritingCellType.numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        HomeWritingCellType.configureCell(self, collectionView, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        HomeWritingCellType.configureCellSize(collectionView, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        HomeWritingCellType.minimumLineSpacingForSection
    }
}
