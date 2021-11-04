//
//  ChattingDetailViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit

class ChattingDetailViewController: UIViewController {

    weak var coordinator: ChattingCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
}

private extension ChattingDetailViewController {
    func configureNavigationBar() {
        let ellipsisButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: nil)
        ellipsisButton.tintColor = .black

        navigationItem.rightBarButtonItem = ellipsisButton
        title = "킬러베어"
    }
}
