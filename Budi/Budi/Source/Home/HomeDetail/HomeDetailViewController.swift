//
//  HomeDetailViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/02.
//

import UIKit
import Moya
import Combine
import CombineCocoa

final class HomeDetailViewController: UIViewController {

    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var backgroundView: UIView!

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var heartCountLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!

    private var isHeartButtonChecked: Bool = false

    weak var coordinator: HomeCoordinator?
    private let viewModel: HomeDetailViewModel
    private var cancellables = Set<AnyCancellable>()

    init?(coder: NSCoder, viewModel: HomeDetailViewModel) {
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
        bottomView.layer.addBorderTop()
        bindViewModel()
        setPublisher()
    }

    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.setTranslucent()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.removeTranslucent()
    }
}

private extension HomeDetailViewController {
    func setPublisher() {
        heartButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.isHeartButtonChecked.toggle()
                self.heartButton.setImage(UIImage(systemName: self.isHeartButtonChecked ? "heart.fill" : "heart"), for: .normal)
                self.heartButton.tintColor = self.isHeartButtonChecked ? UIColor.budiGreen : UIColor.budiGray
            }.store(in: &cancellables)

        submitButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.coordinator?.showBottomSheet(self, self.viewModel)
            }.store(in: &cancellables)
    }

    func bindViewModel() {
        viewModel.state.post
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in
                self?.mainCollectionView.reloadData()
            }, receiveValue: { _ in
                self.mainCollectionView.reloadData()
            }).store(in: &cancellables)
    }

    func configureCollectionView() {
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        
        for cell in HomeDetailCellType.allCases {
            mainCollectionView.register(.init(nibName: cell.type.identifier, bundle: nil), forCellWithReuseIdentifier: cell.type.identifier)
        }
    }
}

extension HomeDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        HomeDetailCellType.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()

        switch indexPath.row {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailMainCell.identifier, for: indexPath) as? HomeDetailMainCell else { return cell }
            if let post = viewModel.state.post.value {
                cell.updateUI(post)
            }
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailStatusCell.identifier, for: indexPath) as? HomeDetailStatusCell else { return cell }
            cell.recruitingStatuses = viewModel.state.recruitingStatuses.value
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailDescriptionCell.identifier, for: indexPath) as? HomeDetailDescriptionCell else { return cell }
            if let post = viewModel.state.post.value {
                cell.updateUI(post.description)
            }
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailLeaderCell.identifier, for: indexPath) as? HomeDetailLeaderCell else { return cell }
            if let leader = viewModel.state.post.value?.leader {
                cell.leader = leader
            }
            return cell
        case 4:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailMemberCell.identifier, for: indexPath) as? HomeDetailMemberCell else { return cell }
            return cell
        default: break
        }

        return cell
    }
}

extension HomeDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: collectionView.frame.width, height: 0)

        let cellType = HomeDetailCellType(rawValue: indexPath.row)
        size.height = cellType?.height ?? 0

        if indexPath.row == 4 {
            size.height = 64 + (99 + 8) * CGFloat(viewModel.state.teamMembers.value.count) + 64
        }

        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

private extension HomeDetailViewController {
    func configureNavigationBar() {
        let actionButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonTapped))
        navigationItem.rightBarButtonItem = actionButton
        navigationController?.navigationBar.tintColor = .systemGray
    }

    @objc
    func actionButtonTapped() {
        let alert = GreetingAlertViewController()
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        present(alert, animated: true, completion: nil)
    }
}
