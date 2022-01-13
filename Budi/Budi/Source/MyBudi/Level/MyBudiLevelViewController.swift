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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureLevelImage()
    }

    func configureLevelImage() {
        var levelImage: String = ""

        switch viewModel.state.loginStatusData.value?.basePosition ?? 1 {
        case 1:
            levelImage += "Dev_"
        case 2:
            levelImage += "Design_"
        case 3:
            levelImage += "Plan_"
        default:
            break
        }
        let level = viewModel.state.loginStatusData.value?.level ?? ""
        switch level {
        case _ where level.contains("씨앗"):
            levelImage += "Lv1"
        case _ where level.contains("열매"):
            levelImage += "Lv2"
        case _ where level.contains("꽃잎"):
            levelImage += "Lv3"
        case _ where level.contains("열매"):
            levelImage += "Lv4"
        default:
            levelImage += "Lv4"
        }

        userLevelImageView.image = UIImage(named: levelImage)
    }

    private func configureLayout() {
        userNameLabel.text = viewModel.state.loginStatusData.value?.nickName ?? "정보없음"
        userLevelLabel.text = viewModel.state.loginStatusData.value?.level ?? "정보없음"
    }
}
