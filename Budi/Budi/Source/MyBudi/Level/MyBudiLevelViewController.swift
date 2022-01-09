//
//  MyBudiLevelViewController.swift
//  Budi
//
//  Created by 인병윤 on 2022/01/09.
//

import UIKit
import Combine
import CombineCocoa

class MyBudiLevelViewController: UIViewController {

    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var userLevelImageView: UIImageView!

    weak var coordinator: MyBudiCoordinator?

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userLevelLabel: UILabel!
    let viewModel: MyBudiMainViewModel

    init?(coder: NSCoder, viewModel: MyBudiMainViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }

    private func configureLayout() {
        userNameLabel.text = viewModel.state.loginStatusData.value?.nickName ?? "정보없음"
        userLevelLabel.text = viewModel.state.loginStatusData.value?.level ?? "정보없음"
    }
}
