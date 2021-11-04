//
//  TeamSearchViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit

class TeamSearchViewController: UIViewController {

    weak var coordinator: TeamSearchCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
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
