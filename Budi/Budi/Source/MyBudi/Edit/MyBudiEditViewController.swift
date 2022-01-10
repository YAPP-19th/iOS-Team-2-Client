//
//  MyBudiEditViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/22.
//

import UIKit
import Combine
import CombineCocoa

final class MyBudiEditViewController: UIViewController {
     
    @IBOutlet weak var tableView: UITableView!
    weak var coordinator: MyBudiCoordinator?
    private let viewModel: MyBudiEditViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(nibName: String?, bundle: Bundle?, viewModel: MyBudiEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - CollectionView
extension MyBudiEditViewController {
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: DefaultHeaderView.cellId, bundle: nil)
        let normal = UINib(nibName: NormalTextFieldTableViewCell.cellId, bundle: nil)
        let location = UINib(nibName: LocationReplaceTableViewCell.cellId, bundle: nil)
        let position = UINib(nibName: PositionTableViewCell.cellId, bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: DefaultHeaderView.cellId)
        tableView.register(normal, forCellReuseIdentifier: NormalTextFieldTableViewCell.cellId)
        tableView.register(<#T##nib: UINib?##UINib?#>, forCellReuseIdentifier: <#T##String#>)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
}

private extension MyBudiEditViewController {
    func configureNavigationBar() {
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("저장", for: .normal)

        let stackview = UIStackView(arrangedSubviews: [saveButton])

        navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: stackview)
        title = "프로필 수정"
    }
}
