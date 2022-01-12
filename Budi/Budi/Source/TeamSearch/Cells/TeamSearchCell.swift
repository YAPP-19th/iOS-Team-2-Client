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
                    let vc = TeamSearchProfileViewController(viewModel: .init())
                    self?.navigationVC?.pushViewController(vc, animated: true)
                }.store(in: &cell.cancellables)
            return cell
        default: return UICollectionViewCell()
        }
    }
}

extension TeamSearchCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width.nextDown - 8) / 2
        let height = width * (178.0 / 167.5)
        return CGSize(width: width, height: height)
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
