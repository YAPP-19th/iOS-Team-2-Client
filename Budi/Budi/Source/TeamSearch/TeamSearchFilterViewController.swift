//
//  TeamSearchFilterViewController.swift
//  Budi
//
//  Created by 최동규 on 2022/01/05.
//

import UIKit
import Combine
import CombineCocoa

final class TeamSearchFilterViewController: UIViewController {

    let viewModel: TeamSearchFilterViewModel

    private var cancellables = Set<AnyCancellable>()

    private let collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumLineSpacing = 8
        collectionViewLayout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    init(viewModel: TeamSearchFilterViewModel, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .budiWhite
        configureCollectionView()
        setPublisher()
        bindViewModel()
    }

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
        view.addSubview(collectionView)

        collectionView.refreshControl = UIRefreshControl()
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.register(.init(nibName: TeamSearchPostionFilterHeader.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TeamSearchPostionFilterHeader.identifier)
        collectionView.register(.init(nibName: TeamSearchDetailCell.identifier, bundle: nil), forCellWithReuseIdentifier: TeamSearchDetailCell.identifier)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension TeamSearchFilterViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.state.sections.value.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.state.sections.value[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TeamSearchPostionFilterHeader.identifier, for: indexPath) as? TeamSearchPostionFilterHeader else { return UICollectionReusableView() }
        header.fetch(position: viewModel.position)
        return header
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamSearchDetailCell.identifier, for: indexPath) as? TeamSearchDetailCell else { return UICollectionViewCell() }

        let item = viewModel.state.sections.value[indexPath.section].items[indexPath.item]
        cell.updateUI(item, position: viewModel.position)
        cell.gesturePublisher(.tap())
            .sink { [weak self] _ in
                if UserDefaults.standard.string(forKey: "accessToken")?.isEmpty ?? false {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginSelectViewController = storyboard.instantiateViewController(identifier: "LoginSelectViewController")
                    let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                    sceneDelegate?.moveLoginController(loginSelectViewController, animated: true)
                } else {
                    let vc = TeamSearchProfileViewController(viewModel: .init(memberID: String(item.id)))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }.store(in: &cell.cancellables)
        cell.postionLabel.superview?.backgroundColor = viewModel.position.labelBackgroundColor
        cell.postionLabel.textColor = viewModel.position.labelTextColor
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 8, left: 16, bottom: 8, right: 16)
    }
}

extension TeamSearchFilterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width.nextDown - 40) / 2
        let height = width * (178.0 / 167.5)
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.bounds.width, height: 154)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.collectionView.contentOffset.y > self.collectionView.contentSize.height - (self.collectionView.bounds.height + 100) && !self.viewModel.nextPageisLoading {
            self.viewModel.nextPageisLoading = true
            self.viewModel.action.fetch.send(())
        }
    }
}
