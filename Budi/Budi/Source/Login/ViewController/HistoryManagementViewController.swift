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
    private let viewModel: SignupViewModel

    private var cancellables = Set<AnyCancellable>()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressView: ProgressView!
    private var section: Int = 0
    private var callCount = 0
    init?(coder: NSCoder, viewModel: SignupViewModel) {
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
        bindViewModel()
        viewModel.action.postCreateInfo.send(())
    }

    private func bindViewModel() {
        viewModel.state.sectionData
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.tableView.reloadData()
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: Notification.Name("Dismiss"))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.modalViewBackgoundOff()
            }
            .store(in: &cancellables)
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
    func addButtonAction(_ button: UIButton) {
    }
    func modalViewBackgoundOn() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.view.alpha = 0.5
        })
    }

    func modalViewBackgoundOff() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.view.alpha = 1.0
        })
    }

    func reloadCells(section: Int) {
        print(section)
        tableView.reloadSections(IndexSet(section...section), with: .none)
    }

    private func showActionSheet(section: Int, index: Int) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let edit = UIAlertAction(title: "수정", style: .default, handler: { _ in
            if section == 0 {
                coordinator?.showCareerViewController()
            } else if section == 1 {
                coordinator?.showProjectViewController()
            } else {
                coordinator?.showPortfolioController()
            }
        })
        let delete = UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            print(section, index)
        })

        let cancel = UIAlertAction(title: "완료", style: .cancel, handler: { _ in
            print(section, index)
        })

        actionSheet.addAction(edit)
        actionSheet.addAction(delete)
        actionSheet.addAction(cancel)

        present(actionSheet, animated: true, completion: nil)
    }

}

extension HistoryManagementViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.state.sectionData.value.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.state.sectionData.value[section].items.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        56
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DefaultHeaderView.cellId) as? DefaultHeaderView else { return UIView() }

        header.configureLabel(title: viewModel.state.sectionData.value[section].sectionTitle)

        header.addButton.tapPublisher
            .sink { [weak self] _ in
                guard let select = self?.viewModel.state.sectionData.value[section].type else { return }
                self?.viewModel.action.appendSectionData.send(select)
                print(select)
                self?.section = section
            }
            .store(in: &header.cancellables)

        return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: DefaultTableViewCell.cellId, for: indexPath) as? DefaultTableViewCell else { return UITableViewCell() }
        let data = viewModel.state.sectionData.value[indexPath.section].items[indexPath.row]
        print(data)
        if data.itemInfo.isInclude {
            if data.portfolioLink.count >= 1 {
                cell.configurePortfolioLabel(link: data.portfolioLink)
            } else {
                cell.configureLabel(main: data.name, date: data.startDate + " ~ " + data.endDate, sub: data.description)
            }
        } else {
            cell.configureButtonTitle(title: data.itemInfo.buttonTitle)
        }

        cell.addButton.tapPublisher
            .sink { [weak self] _ in
                if indexPath.section == 0 {
                    self?.coordinator?.showCareerViewController()
                    self?.section = indexPath.section
                    self?.viewModel.action.cellSelectIndex.send([indexPath.section, indexPath.item])
                } else if indexPath.section == 1 {
                    self?.coordinator?.showProjectViewController()
                    self?.section = indexPath.section
                    self?.viewModel.action.cellSelectIndex.send([indexPath.section, indexPath.item])
                } else if indexPath.section == 2 {
                    self?.coordinator?.showPortfolioController()
                    self?.section = indexPath.section
                    self?.viewModel.action.cellSelectIndex.send([indexPath.section, indexPath.item])
                }
                self?.modalViewBackgoundOn()
            }
            .store(in: &cell.cancellables)

        cell.portfolioMoreButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.showActionSheet(section: indexPath.section, index: indexPath.item)
            }
            .store(in: &cell.cancellables)

        cell.moreButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.showActionSheet(section: indexPath.section, index: indexPath.item)
            }
            .store(in: &cell.cancellables)

        return cell
    }
}
