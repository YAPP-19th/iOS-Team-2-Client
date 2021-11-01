//
//  TeamRecrutimentViewController.swift
//  Budi
//
//  Created by 최동규 on 2021/10/11.
//

import UIKit

final class TeamRecruitmentViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    weak var coordinator: TeamRecruitmentCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
    }

    @IBAction func writeButtonDidTouchUpInside(_ sender: UIButton) {
        coordinator?.showWriting()
    }

}

extension TeamRecruitmentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
       0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        return UICollectionViewCell()
    }
}

extension TeamRecruitmentViewController: UICollectionViewDelegate {

}

private extension TeamRecruitmentViewController {
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
