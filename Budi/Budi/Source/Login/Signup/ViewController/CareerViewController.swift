//
//  CareerViewController.swift
//  Budi
//
//  Created by 인병윤 on 2021/12/15.
//

import UIKit
import Combine
import CombineCocoa

class CareerViewController: UIActivityViewController {
    private let controller: UIViewController!
    let viewModel: SignupViewModel
    weak var coordinator: LoginCoordinator?
    private var cancellables = Set<AnyCancellable>()
    @IBOutlet weak var historyNoSwitch: HistoryNoCheckDateView!

    override func viewWillAppear(_ animated: Bool) {
        switchView()
    }

    required init(controller: UIViewController, viewModel: SignupViewModel) {
        self.controller = controller
        self.viewModel = viewModel
        super.init(activityItems: [], applicationActivities: nil)
        switchView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let subViews = self.view.subviews
        for view in subViews {
            view.removeFromSuperview()
        }
        self.addChild(controller)
        self.view.addSubview(controller.view)
        switchView()
    }

    func switchView() {
        viewModel.state.modalView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewNumber in
                switch viewNumber {
                case .company:
                    self?.historyNoSwitch.isHidden = true
                case .project:
                    self?.historyNoSwitch.isHidden = false
                case .none:
                    break
                }
            }
            .store(in: &cancellables)
    }
}
