//
//  HistoryWriteViewController.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/25.
//

import UIKit
import CombineCocoa
import Combine
class HistoryWriteViewController: UIViewController {
    var viewModel: SignupViewModel
    weak var coordinator: LoginCoordinator?
    private var cancellables = Set<AnyCancellable>()
    private var currentButtonTag: Int = 0

    @IBOutlet weak var historyNoSwitchView: UIView!
    @IBOutlet weak var historySwitchView: UIView!
    @IBOutlet weak var modalView: UIView!
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)

        return button
    }()

    override func viewWillAppear(_ animated: Bool) {
        viewModel.state.modalView
            .receive(on: DispatchQueue.main)
            .sink { data in
                switch data {
                case .company:
                    self.modalView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 500)
                    self.historyNoSwitchView.isHidden = true
                    self.historySwitchView.isHidden = false
                case .project:
                    self.historyNoSwitchView.isHidden = false
                    self.historySwitchView.isHidden = true
                    self.modalView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400)
                case .none:
                    break
                }
            }
            .store(in: &cancellables)
    }

    init?(coder: NSCoder, viewModel: SignupViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("This viewController must be init with viewModel")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        self.addBackButton()
        configureLayout()
        setButtonAction()
    }

    private func setButtonAction() {
        doneButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                print("Hello")
            }
            .store(in: &cancellables)
    }

    private func configureLayout() {
        modalView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        modalView.layer.cornerRadius = 10
    }

}
