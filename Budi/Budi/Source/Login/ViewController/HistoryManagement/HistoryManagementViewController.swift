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

    @IBOutlet weak var blackBackground: UIView!
    @IBOutlet weak var doneButton: UIButton!
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
        blackBackground.alpha = 0.0
        buttonPublisher()
    }

    private func buttonPublisher() {
        doneButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.viewModel.action.postCreateInfo.send(())
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
            .store(in: &cancellables)
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
        let portNib = UINib(nibName: PortfolioURLTableViewCell.cellId, bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: DefaultHeaderView.cellId)
        tableView.register(portNib, forCellReuseIdentifier: PortfolioURLTableViewCell.cellId)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none

    }

    @objc
    func addButtonAction(_ button: UIButton) {
    }

    func modalViewBackgoundOn() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            self.blackBackground.alpha = 0.5
        })
    }

    func modalViewBackgoundOff() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.blackBackground.alpha = 0.0
        })
    }

    func reloadCells(section: Int) {
        tableView.reloadSections(IndexSet(section...section), with: .none)
    }

    private func showActionSheet(section: Int, index: Int) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let edit = UIAlertAction(title: "수정", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.action.cellSelectIndex.send([section, index])
            self.viewModel.action.loadEditData.send(())
            self.modalViewBackgoundOn()
            if section == 0 {
                self.coordinator?.showProjectViewController(viewModel: self.viewModel)
            } else if section == 1 {
                self.coordinator?.showPortfolioController(viewModel: self.viewModel)
            }
        })
        let delete = UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            self.viewModel.action.cellSelectIndex.send([section, index])
            self.viewModel.action.deleteSignupInfoData.send(())
        })

        let cancel = UIAlertAction(title: "완료", style: .cancel)

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
                self?.section = section
            }
            .store(in: &header.cancellables)

        return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: DefaultTableViewCell.cellId, for: indexPath) as? DefaultTableViewCell else { return UITableViewCell() }
        let data = viewModel.state.sectionData.value[indexPath.section].items[indexPath.row]

        if data.itemInfo.isInclude {
            if data.portfolioLink.count >= 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PortfolioURLTableViewCell.cellId, for: indexPath) as? PortfolioURLTableViewCell else { return UITableViewCell() }
                cell.configureParsing(url: data.portfolioLink)

                cell.editButton.tapPublisher
                    .receive(on: DispatchQueue.main)
                    .sink { _ in
                        self.viewModel.action.setSignupInfoData.send(())
                        self.showActionSheet(section: indexPath.section, index: indexPath.item)
                    }
                    .store(in: &cell.cancellables)

                return cell
            } else {
                cell.configureLabel(main: data.name, date: data.startDate + " ~ " + data.endDate, sub: data.description)
            }
        } else {
            cell.configureButtonTitle(title: data.itemInfo.buttonTitle)
        }

        cell.addButton.tapPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.action.cellSelectIndex.send([indexPath.section, indexPath.item])
                self.viewModel.action.setSignupInfoData.send(())
                self.viewModel.state.editData.send(nil)
                if indexPath.section == 0 {
                    self.coordinator?.showProjectViewController(viewModel: self.viewModel)
                    self.section = indexPath.section
                } else if indexPath.section == 1 {
                    self.coordinator?.showPortfolioController(viewModel: self.viewModel)
                    self.section = indexPath.section
                }
                self.modalViewBackgoundOn()
            }
            .store(in: &cell.cancellables)

        cell.moreButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.viewModel.action.setSignupInfoData.send(())
                self.showActionSheet(section: indexPath.section, index: indexPath.item)
            }
            .store(in: &cell.cancellables)

        return cell
    }
}
