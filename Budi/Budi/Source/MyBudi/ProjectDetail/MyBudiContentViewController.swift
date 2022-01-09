//
//  MyBudiContentViewController.swift
//  Budi
//
//  Created by 인병윤 on 2022/01/09.
//

import UIKit
import Combine
import CombineCocoa

class MyBudiContentViewController: UIViewController {

    let viewModel: MyBudiMainViewModel
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: MyBudiCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
    }

    init(viewModel: MyBudiMainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    init?(coder: NSCoder, viewModel: MyBudiMainViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("This viewController must be init with viewModel")
    }

}

private extension MyBudiContentViewController {

    func configureCollectionView() {
        view.addSubview(collectionView)

        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        collectionView.refreshControl = UIRefreshControl()
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.register(.init(nibName: MyBudiProjectDetailCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: MyBudiProjectDetailCollectionViewCell.identifier)
    }
}

extension MyBudiContentViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyBudiProjectDetailCollectionViewCell.identifier, for: indexPath) as? MyBudiProjectDetailCollectionViewCell else { return UICollectionViewCell() }

        return cell
    }

}

extension MyBudiContentViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 343, height: 100)
    }
}
