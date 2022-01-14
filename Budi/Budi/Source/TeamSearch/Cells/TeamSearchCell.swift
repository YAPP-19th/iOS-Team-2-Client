//
//  TeamSearchCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit
import Combine

final class TeamSearchCell: UICollectionViewCell {

    @IBOutlet private weak var headerImageView: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var headerTitleLabel: UILabel!
    @IBOutlet weak var headerStackView: UIStackView!
    var cancellables = Set<AnyCancellable>()
    var section: TeamSearchSection?
    private weak var navigationVC: UINavigationController?

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }

    func bind(navigationVC: UINavigationController? = nil) {
        self.navigationVC = navigationVC
    }

    func updateUI(_ section: TeamSearchSection) {
        self.section = section
        headerTitleLabel.text = section.title
        switch self.section?.type {
        case .position:
            guard let section = section as? TeamSearchPositionSection else { return }
            headerImageView.image = section.position.teamSearchCharacter
        default:
            headerImageView.isHidden = true
        }
        collectionView.reloadData()
    }
}

private extension TeamSearchCell {
    func configure() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8
        collectionView.collectionViewLayout = flowLayout
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.register(.init(nibName: TeamSearchDetailCell.identifier, bundle: nil), forCellWithReuseIdentifier: TeamSearchDetailCell.identifier)
        collectionView.register(.init(nibName: TeamSearchEvaluationCell.identifier, bundle: nil), forCellWithReuseIdentifier: TeamSearchEvaluationCell.identifier)
        collectionView.register(.init(nibName: TeamSearchReviewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TeamSearchReviewCell.identifier)
        collectionView.register(.init(nibName: ProjectHistoryCell.identifier, bundle: nil), forCellWithReuseIdentifier: ProjectHistoryCell.identifier)
        collectionView.register(.init(nibName: PortfolioCell.identifier, bundle: nil), forCellWithReuseIdentifier: PortfolioCell.identifier)
    }
}

extension TeamSearchCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.section?.type {
        case .position:
            guard let section = self.section as? TeamSearchPositionSection else { return 0 }
            return section.items.count
        case .evalution:
            guard let section = self.section as? TeamSearchEvalutionSection else { return 0 }
            let evalutions = section.item.negatives.merging(section.item.positives, uniquingKeysWith: { current, _ in
                return current
            })
            return evalutions.count > 3 ? 3 : evalutions.count
        case .review:
            return 1
//            guard let section = self.section as? TeamSearchReviewSection else { return 0 }
//            return section.items.count > 2 ? 2 : section.items.count
        case .history:
            guard let section = self.section as? TeamSearchHistorySection else { return 0 }
            return section.items.count > 3 ? 3 : section.items.count
        case .portfolio:
            guard let section = self.section as? TeamSearchPortfolioSection else { return 0 }
            return section.items.count > 3 ? 3 : section.items.count
        default: return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch self.section?.type {
        case .position:
            guard let section = section as? TeamSearchPositionSection,
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamSearchDetailCell.identifier, for: indexPath) as? TeamSearchDetailCell else { return UICollectionViewCell() }
            let member = section.items[indexPath.item]
            cell.updateUI(member, position: section.position)
            cell.gesturePublisher(.tap())
                .sink { [weak self] _ in
                    if UserDefaults.standard.string(forKey: "accessToken")?.isEmpty ?? false {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let loginSelectViewController = storyboard.instantiateViewController(identifier: "LoginSelectViewController")
                        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                        sceneDelegate?.moveLoginController(loginSelectViewController, animated: true)
                    } else {
                        let vc = TeamSearchProfileViewController(viewModel: .init(memberID: String(member.id)))
                        self?.navigationVC?.pushViewController(vc, animated: true)
                    }
                }.store(in: &cell.cancellables)
            return cell
        case .evalution:
            guard let section = self.section as? TeamSearchEvalutionSection,
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamSearchEvaluationCell.identifier, for: indexPath) as? TeamSearchEvaluationCell else { return UICollectionViewCell() }
            let evalutions = Array(section.item.negatives.merging(section.item.positives, uniquingKeysWith: { current, _ in
                return current
            }))
            cell.updateUI(title: evalutions[indexPath.item].key, count: evalutions[indexPath.item].value)
            return cell
        case .review:
            guard let section = self.section as? TeamSearchReviewSection,
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamSearchReviewCell.identifier, for: indexPath) as? TeamSearchReviewCell else { return UICollectionViewCell() }
//            let review = section.items[indexPath.item]
            return cell
        case .history:
            guard let section = self.section as? TeamSearchHistorySection,
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectHistoryCell.identifier, for: indexPath) as? ProjectHistoryCell else { return UICollectionViewCell() }
      let project = section.items[indexPath.item]
            cell.updateUI(project: project)
            return cell
        case .portfolio:
            guard let section = self.section as? TeamSearchPortfolioSection,
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PortfolioCell.identifier, for: indexPath) as? PortfolioCell else { return UICollectionViewCell() }
            cell.updateUI(urlString: section.items[indexPath.item])
            return cell
        default: return UICollectionViewCell()
        }
    }
}

extension TeamSearchCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch self.section?.type {
        case .position:
        let width = (collectionView.bounds.width.nextDown - 8) / 2
        let height = width * (178.0 / 167.5)
        return CGSize(width: width, height: height)
        case .evalution:
            return CGSize(width: collectionView.bounds.width, height: 53)
        case .review:
            return CGSize(width: collectionView.bounds.width, height: 254)
        case .history:
            return CGSize(width: collectionView.bounds.width, height: 100)
        case .portfolio:
            return CGSize(width: collectionView.bounds.width, height: 48)
        default: return .zero
        }
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
