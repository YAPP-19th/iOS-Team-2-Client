//
//  TeamSearchViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit
import CombineCocoa
import Combine

final class TeamSearchViewController: UIViewController {

    let viewModel: TeamSearchViewModel
    @IBOutlet private weak var collectionView: UICollectionView!
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: TeamSearchCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCollectionView()
        setPublisher()
        bindViewModel()
    }

    init(viewModel: TeamSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    init?(coder: NSCoder, viewModel: TeamSearchViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("This viewController must be init with viewModel")
    }
}

private extension TeamSearchViewController {
    func setPublisher() {
        collectionView.refreshControl?.isRefreshingPublisher
            .sink(receiveValue: { [weak self] isRefreshing in
                guard isRefreshing else { return }
                self?.viewModel.action.refresh.send(())
            })
            .store(in: &cancellables)
    }

    func bindViewModel() {
        viewModel.state.sections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.refreshControl?.endRefreshing()
                self?.collectionView.reloadData()
            }.store(in: &cancellables)
    }

    func configureCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = flowLayout
        collectionView.backgroundColor = .background
        collectionView.refreshControl = UIRefreshControl()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(.init(nibName: TeamSearchCell.identifier, bundle: nil), forCellWithReuseIdentifier: TeamSearchCell.identifier)
    }
}

extension TeamSearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.state.sections.value.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamSearchCell.identifier, for: indexPath) as? TeamSearchCell else { return UICollectionViewCell() }
        let item = viewModel.state.sections.value[indexPath.section]
        cell.updateUI(item)
        cell.headerStackView.gesturePublisher(.tap())
            .sink { [weak self] _ in
                let vc = TeamSearchFilterViewController(viewModel: .init(position: item.position))
                let imageView = UIImageView()
                imageView.image = item.position.teamSearchCharacter
                vc.navigationItem.titleView = imageView
                self?.navigationController?.pushViewController(vc, animated: true)
            }.store(in: &cell.cancellables)
        return cell
    }
}

extension TeamSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ratio = 468.0 / 375.0
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width * ratio)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 8, right: 0)
    }
}

private extension TeamSearchViewController {
    func configureNavigationBar() {
        let searchButton = UIButton()
        searchButton.setImage(.init(systemName: "magnifyingglass"), for: .normal)

        let notifyButton = UIButton()
        notifyButton.setImage(.init(systemName: "bell"), for: .normal)

        let stackview = UIStackView(arrangedSubviews: [searchButton, notifyButton])
        stackview.distribution = .equalSpacing
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 8

        navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: stackview)
        title = "버디 찾기"
    }
}
