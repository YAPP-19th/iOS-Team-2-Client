//
//  MyBudiViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/21.
//

import UIKit

final class MyBudiViewController: UIViewController {
    
    weak var coordinator: MyBudiCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
}

private extension MyBudiViewController {
    func configureNavigationBar() {
        let notifyButton = UIButton()
        notifyButton.setImage(.init(systemName: "bell"), for: .normal)

        let stackview = UIStackView(arrangedSubviews: [notifyButton])

        navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: stackview)
        title = "나의 버디"
    }
}
