//
//  HistoryManagementViewController.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/24.
//

import UIKit
import CombineCocoa
import Combine

class HistoryManagementViewController: UIViewController {
    weak var coordinator: LoginCoordinator?
    private let viewModel: HistoryManagementViewModel

    private var cancellables = Set<AnyCancellable>()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressView: ProgressView!

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    init?(coder: NSCoder, viewModel: HistoryManagementViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("This viewController must be init with viewModel")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        configureLayout()
    }

    private func configureLayout() {
        tableView.dataSource = self
        tableView.delegate = self
        progressView.changeColor(index: 3)

        let nib = UINib(nibName: DefaultHeaderView.cellId, bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: DefaultHeaderView.cellId)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none

    }

    @objc
    func buttonAction(_ button: UIButton) {
        print(button.tag)
        let uuid = UUID()
        viewModel.historyArray[button.tag].append(uuid)
        tableView.reloadData()
    }

    @objc
    func addButtonAction(_ button: UIButton) {
    }

}

extension HistoryManagementViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.historyArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.historyArray[section].count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        56
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: DefaultHeaderView.cellId) as? DefaultHeaderView else { return UIView() }
        if section < 2 {
            header.titleLabel.text = viewModel.getHeaderData()[section]
        } else {
            header.titleLabel.text = viewModel.getHeaderData()[section]
        }

        header.addButton.tag = section
        header.addButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: DefaultTableViewCell.cellId, for: indexPath) as? DefaultTableViewCell else { return UITableViewCell() }
        if indexPath.section == 0 {
            cell.addButton.setTitle("경력을 추가해보세요", for: .normal)
            cell.addButton.tapPublisher
                .sink { [weak self] _ in
                    self?.coordinator?.showHistoryWriteViewController(1)
                }
                .store(in: &cell.cancellables)
        } else if indexPath.section == 1 {
            cell.addButton.setTitle("프로젝트 이력을 추가해보세요", for: .normal)
            cell.addButton.tapPublisher
                .sink { [weak self] _ in
                    self?.coordinator?.showHistoryWriteViewController(2)
                }
                .store(in: &cell.cancellables)
        } else if indexPath.section == 2 {
            cell.addButton.setTitle("포트폴리오를 추가해보세요.", for: .normal)
        }

        cell.selectView.isHidden = indexPath.section != 0

        cell.addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        cell.addButton.tag = indexPath.section

        return cell
    }
}
