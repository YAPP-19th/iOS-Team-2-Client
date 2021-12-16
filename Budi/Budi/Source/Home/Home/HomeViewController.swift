//
//  HomeViewController.swift
//  Budi
//
//  Created by 최동규 on 2021/10/11.
//

import UIKit
import Moya
import Combine
import CombineCocoa

final class HomeViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var teamAddButton: UIButton!

    weak var coordinator: HomeCoordinator?

    private let viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()
    init?(coder: NSCoder, viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("This viewController must be init with viewModel")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCollectionView()
        bindViewModel()
        setPublisher()
    }
}

private extension HomeViewController {

    func setPublisher() {
        teamAddButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.coordinator?.showWriting()
            }.store(in: &cancellables)

        collectionView.refreshControl?.isRefreshingPublisher
            .sink(receiveValue: { [weak self] isRefreshing in
                guard isRefreshing else { return }
                self?.viewModel.action.refresh.send(())
            })
            .store(in: &cancellables)
    }

    func bindViewModel() {
        viewModel.state.posts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.refreshControl?.endRefreshing()
                self?.collectionView.reloadData()
            }.store(in: &cancellables)
    }

    func configureCollectionView() {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.collectionViewLayout = createLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(.init(nibName: HomeCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeCell.identifier)
        collectionView.backgroundColor = .white
    }
}
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.state.posts.value.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.identifier, for: indexPath) as? HomeCell else { return UICollectionViewCell() }
        let post = viewModel.state.posts.value[indexPath.item]
        cell.updateUI(post)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = viewModel.state.posts.value[indexPath.item]
        coordinator?.showDetail(post.postID)
    }
}

extension HomeViewController: UICollectionViewDelegate {

}

private extension HomeViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in

            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(263 / 343)))
            item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 0)

            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100)), subitems: [item])

            let section = NSCollectionLayoutSection(group: group)

            section.contentInsets = .init(top: 27, leading: 16, bottom: 0, trailing: 16)

            return section
        }
    }

    func configureNavigationBar() {
        let editButton = UIButton()
        editButton.setImage(.init(systemName: "line.3.horizontal"), for: .normal)

        let searchButton = UIButton()
        searchButton.setImage(.init(systemName: "magnifyingglass"), for: .normal)

        let notifyButton = UIButton()
        notifyButton.setImage(.init(systemName: "bell"), for: .normal)

        let stackview = UIStackView(arrangedSubviews: [editButton, searchButton, notifyButton])
        stackview.distribution = .equalSpacing
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 8

        navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: stackview)
        title = "버디 모집"
    }
}
