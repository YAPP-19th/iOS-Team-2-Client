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

    @IBOutlet weak var bottomSheetContainerView: UIView!
    @IBOutlet weak var bottomSheetCollectionView: UICollectionView!
    @IBOutlet weak var bottomSheetCloseButton: UIButton!

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var heartCountLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!

    private var isBottomViewShown: Bool = false
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
                guard let self = self, !self.isBottomViewShown else { return }
                self.backgroundView.isHidden = false
                self.isBottomViewShown = true
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: { [weak self] in
                    self?.bottomSheetContainerView.center.y -= self?.bottomSheetContainerView.bounds.height ?? 0
                }, completion: nil)
            }.store(in: &cancellables)

        bottomSheetCloseButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.isBottomViewShown = false
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: { [weak self] in
                    self?.bottomSheetContainerView.center.y += self?.bottomSheetContainerView.bounds.height ?? 0
                }, completion: { [weak self] _ in
                    self?.backgroundView.isHidden = true
                })
            }.store(in: &cancellables)
    }

    func bindViewModel() {
        viewModel.state.post
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in
                self?.mainCollectionView.reloadData()
            }, receiveValue: { _ in
                self.mainCollectionView.reloadData()
                self.bottomSheetCollectionView.reloadData()
            }).store(in: &cancellables)
    }

    func configureCollectionView() {
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        mainCollectionView.register(.init(nibName: HomeDetailMainCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailMainCell.identifier)
        mainCollectionView.register(.init(nibName: HomeDetailStatusCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailStatusCell.identifier)
        mainCollectionView.register(.init(nibName: HomeDetailDescriptionCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailDescriptionCell.identifier)
        mainCollectionView.register(.init(nibName: HomeDetailLeaderCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailLeaderCell.identifier)
        mainCollectionView.register(.init(nibName: HomeDetailMemberCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeDetailMemberCell.identifier)

        bottomSheetCollectionView.dataSource = self
        bottomSheetCollectionView.delegate = self
        bottomSheetCollectionView.register(.init(nibName: BottomSheetCell.identifier, bundle: nil), forCellWithReuseIdentifier: BottomSheetCell.identifier)
    }
}

extension HomeDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case mainCollectionView: return 5
        case bottomSheetCollectionView: return viewModel.state.post.value?.recruitingStatusResponses.count ?? 0
        default: return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()

        if collectionView == mainCollectionView {
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
        }

        if collectionView == bottomSheetCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomSheetCell.identifier, for: indexPath) as? BottomSheetCell else { return cell }
            if let recruitingStatusResponses = viewModel.state.post.value?.recruitingStatusResponses[indexPath.row] {
                cell.updateUI(status: recruitingStatusResponses)
            }
            return cell
        }

        return cell
    }
}

extension HomeDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: collectionView.frame.width, height: 0)

        if collectionView == mainCollectionView {
            switch indexPath.row {
            case 0: size.height = 280 + 156 + 8
            case 1: size.height = 172 + 8
            case 2: size.height = 200 + 8
            case 3: size.height = (80 + 99) + 8
            case 4: size.height = 64 + (99 + 8) * CGFloat(viewModel.state.teamMembers.value.count) + 64
            default: break
            }
        }

        if collectionView == bottomSheetCollectionView {
            size.height = 56
        }

        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case mainCollectionView: return 0
        case bottomSheetCollectionView: return 8
        default: return 0
        }
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
