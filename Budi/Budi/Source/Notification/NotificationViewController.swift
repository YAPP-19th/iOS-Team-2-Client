//
//  NotificationViewController.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/18.
//

import UIKit
import Moya
import Combine
import CombineCocoa

final class NotificationViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var refreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .primary
        return refreshControl
    }()
    
    var viewModel: NotificationViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(nibName: String?, bundle: Bundle?, viewModel: NotificationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bindViewModel()
        setPublisher()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.popViewController(animated: true)
    }
    
    private func bindViewModel() {
        viewModel.state.notifications
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                let notifications = self.viewModel.state.notifications.value
                print("vc notifications: \(notifications)")
                self.collectionView.reloadData()
            }).store(in: &cancellables)
    }
    
    private func setPublisher() {
    }
}

// MARK: - CollectionView
extension NotificationViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(.init(nibName: NotificationListCell.identifier, bundle: nil), forCellWithReuseIdentifier: NotificationListCell.identifier)
        
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
    }
    
    @objc
    private func refreshCollectionView() {
        viewModel.action.refresh.send()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.state.notifications.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationListCell.identifier, for: indexPath) as? NotificationListCell else { return UICollectionViewCell() }
        let notification = viewModel.state.notifications.value[indexPath.row]
        cell.configureUI(notification)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
