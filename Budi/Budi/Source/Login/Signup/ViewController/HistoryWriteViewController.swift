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

    @IBOutlet weak var firstTextField: UITextField!

    @IBOutlet weak var workingSwitchButton: UIButton!
    @IBOutlet weak var leftDatePick: UITextField!
    @IBOutlet weak var rightDatePick: UITextField!
    @IBOutlet weak var secondTextField: UITextField!

    @IBOutlet weak var saveButton: UIButton!

    override func viewWillAppear(_ animated: Bool) {
        viewModel.state.reUseModalView
            .receive(on: DispatchQueue.main)
            .sink { data in
                switch data {
                case .company:
                    self.historyNoSwitchView.isHidden = true
                    self.historySwitchView.isHidden = false
                case .project:
                    self.historyNoSwitchView.isHidden = false
                    self.historySwitchView.isHidden = true
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

        

        saveButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink {
                print("할루~")
            }
            .store(in: &cancellables)

    }

    private func configureLayout() {
        modalView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        modalView.layer.cornerRadius = 10
    }

}
