//
//  PortfolioViewController.swift
//  Budi
//
//  Created by 인병윤 on 2021/12/15.
//

import UIKit
import Combine
import CombineCocoa

class PortfolioViewController: UIViewController {

    weak var coordinator: LoginCoordinator?
    @IBOutlet weak var modalView: UIView!
    var viewModel: SignupViewModel
    private var cancellables = Set<AnyCancellable>()

    init?(coder: NSCoder, viewModel: SignupViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("This viewController must be init with viewModel")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureLayout()
    }

    private func configureLayout() {
        view.backgroundColor = .clear
        modalView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        modalView.layer.cornerRadius = 10
    }
}
