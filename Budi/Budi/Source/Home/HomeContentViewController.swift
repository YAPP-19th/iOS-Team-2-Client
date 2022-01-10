//
//  HomeContentViewController.swift
//  Budi
//
//  Created by 최동규 on 2021/12/14.
//

import UIKit
import CombineCocoa
import Combine

final class HomeContentViewController: UIViewController {

    let viewModel: HomeContentViewModel
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: HomeCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        configureCollectionView()
        setPublisher()
        bindViewModel()
    }

    init(viewModel: HomeContentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    init?(coder: NSCoder, viewModel: HomeContentViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("This viewController must be init with viewModel")
    }
}

private extension HomeContentViewController {

    func setPublisher() {
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
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.collectionViewLayout = createFlowLayout()
        collectionView.register(.init(nibName: HomeCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeCell.identifier)
    }
}

extension HomeContentViewController: UICollectionViewDataSource {
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

        if UserDefaults.standard.string(forKey: "accessToken")?.isEmpty ?? false {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginSelectViewController = storyboard.instantiateViewController(identifier: "LoginSelectViewController")
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegate?.moveLoginController(loginSelectViewController, animated: true)
        } else {
            coordinator?.showDetail(post.postID)
        }
    }
}

extension HomeContentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return homecellsize(for: indexPath)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.collectionView.contentOffset.y > self.collectionView.contentSize.height - (self.collectionView.bounds.height + 100) && !self.viewModel.nextPageisLoading {
            self.viewModel.nextPageisLoading = true
            self.viewModel.action.fetch.send(())
        }
    }
}

private extension HomeContentViewController {

    func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = .init(top: 27, left: 16, bottom: 0, right: 16)
        return layout
    }

    private func homecellsize(for indexPath: IndexPath) -> CGSize {
        guard let homeCell = Bundle.main.loadNibNamed(HomeCell.identifier, owner: self, options: nil)?.first as? HomeCell else { return .zero}
        let post = viewModel.state.posts.value[indexPath.item]
        homeCell.updateUI(post)
        homeCell.setNeedsLayout()
        homeCell.layoutIfNeeded()

        let width = collectionView.bounds.width - 32
        let height: CGFloat = width * (230 / 343)
        + homeCell.collectionView.contentSize.height
        return .init(width: width, height: height)
    }
}
