//
//  TeamRecrutimentViewController.swift
//  Budi
//
//  Created by 최동규 on 2021/10/11.
//

import UIKit

final class TeamRecruitmentViewController: UIViewController {

    weak var coordinator: TeamRecruitmentCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func writeButtonDidTouchUpInside(_ sender: UIButton) {
        coordinator?.showWriting()
    }

}
