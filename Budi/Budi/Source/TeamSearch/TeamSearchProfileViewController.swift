//
//  TeamSearchProfileViewController.swift
//  Budi
//
//  Created by 최동규 on 2022/01/11.
//

import UIKit
import Combine
import CombineCocoa

final class TeamSearchProfileViewController: UIViewController {
    let viewModel: TeamSearchProfileViewModel

    private var cancellables = Set<AnyCancellable>()

    private let collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumLineSpacing = 8
        collectionViewLayout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    init(viewModel: TeamSearchProfileViewModel, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
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
}

private extension TeamSearchProfileViewController {
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
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = flowLayout
        collectionView.backgroundColor = .background
        collectionView.refreshControl = UIRefreshControl()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(.init(nibName: TeamSearchProfileCell.identifier, bundle: nil), forCellWithReuseIdentifier: TeamSearchProfileCell.identifier)
        collectionView.register(.init(nibName: TeamSearchEvaluationCell.identifier, bundle: nil), forCellWithReuseIdentifier: TeamSearchEvaluationCell.identifier)
        collectionView.register(.init(nibName: TeamSearchReviewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TeamSearchReviewCell.identifier)
        collectionView.register(.init(nibName: ProjectHistoryCell.identifier, bundle: nil), forCellWithReuseIdentifier: ProjectHistoryCell.identifier)
        collectionView.register(.init(nibName: PortfolioCell.identifier, bundle: nil), forCellWithReuseIdentifier: PortfolioCell.identifier)

        collectionView.register(.init(nibName: TeamSearchCell.identifier, bundle: nil), forCellWithReuseIdentifier: TeamSearchCell.identifier)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension TeamSearchProfileViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamSearchProfileCell.identifier, for: indexPath) as? TeamSearchProfileCell else { return UICollectionViewCell() }
            cell.backgroundColor = .white
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamSearchCell.identifier, for: indexPath) as? TeamSearchCell else { return UICollectionViewCell() }
            cell.updateUI(TeamSearchEvalutionSection(items: []))
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamSearchCell.identifier, for: indexPath) as? TeamSearchCell else { return UICollectionViewCell() }
            cell.updateUI(TeamSearchReviewSection(items: []))
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamSearchCell.identifier, for: indexPath) as? TeamSearchCell else { return UICollectionViewCell() }
            cell.updateUI(TeamSearchHistorySection(items: []))
            return cell
        case 4:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamSearchCell.identifier, for: indexPath) as? TeamSearchCell else { return UICollectionViewCell() }
            cell.updateUI(TeamSearchPortfolioSection(items: []))
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamSearchCell.identifier, for: indexPath) as? TeamSearchCell else { return UICollectionViewCell() }
            return cell
        }
    }
}

extension TeamSearchProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return .init(width: collectionView.bounds.width, height: 172)
        case 1:
            return .init(width: collectionView.bounds.width, height: 259)
        case 2:
            return .init(width: collectionView.bounds.width, height: 456)
        case 3:
            return .init(width: collectionView.bounds.width, height: 400)
        case 4:
            return .init(width: collectionView.bounds.width, height: 232)
        default:
            return .zero
        }
    }
}
//
struct TeamSearchEvalutionSection: TeamSearchSection {
    let title: String = "버디 평가"
    let type: TeamSearchSectionType = .evalution
    var items: [SearchTeamMember]
}

struct TeamSearchReviewSection: TeamSearchSection {
    let title: String = "버디 후기"
    let type: TeamSearchSectionType = .review
    var items: [SearchTeamMember]
}

struct TeamSearchHistorySection: TeamSearchSection {
    let title: String = "프로젝트 이력"
    let type: TeamSearchSectionType = .history
    var items: [SearchTeamMember]
}

struct TeamSearchPortfolioSection: TeamSearchSection {
    let title: String = "포트폴리오"
    let type: TeamSearchSectionType = .portfolio
    var items: [SearchTeamMember]
}


// /api/v1/invitations
// /api/v1/members/budiDetails/{memberId}
// /api/v1/select-reviews
// /api/v1/text-reviews
//
