//
//  MyBudiEditViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/22.
//

import UIKit
import Combine
import CombineCocoa
import Kingfisher
import PhotosUI

final class MyBudiEditViewController: UIViewController {
     
    @IBOutlet weak var imageEditButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImageView: UIImageView!
    weak var coordinator: MyBudiCoordinator?
    var viewModel: MyBudiEditViewModel
    private var cancellables = Set<AnyCancellable>()
    var editIndex: Int = -1

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
        configureTableView()
        setPublisher()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    func setPublisher() {
        NotificationCenter.default.publisher(for: Notification.Name("Dismiss"))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.modalViewBackgoundOff()
            }
            .store(in: &cancellables)

        viewModel.state.dataChanged
            .receive(on: DispatchQueue.main)
            .sink { [weak self] idx in
                guard let self = self else { return }
                self.tableView.reloadSections(IndexSet(integer: idx), with: .automatic)
            }
            .store(in: &cancellables)

        imageEditButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.editUserImageAlert()
            }
            .store(in: &cancellables)



    }

    func modalViewBackgoundOn() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            self.view.alpha = 0.5
        })
    }

    func modalViewBackgoundOff() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.alpha = 1.0
        })
    }

    private func showActionSheet(section: Int, index: Int) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        editIndex = index
        let edit = UIAlertAction(title: "수정", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.modalViewBackgoundOn()
            if section == 0 {
                let signViewModel = SignupViewModel()
                guard let projectData = self.viewModel.state.loginUserData.value?.projectList[index] else { return }
                signViewModel.state.editData.value = Item(itemInfo: ItemInfo(isInclude: true, buttonTitle: ""),
                                                          description: projectData.description,
                                                          endDate: projectData.endDate,
                                                          name: projectData.name,
                                                          nowWork: false,
                                                          startDate: projectData.startDate,
                                                          portfolioLink: "")

                self.coordinator?.showProjectViewController(self, viewModel: signViewModel)
            } else if section == 1 {
                let signViewModel = SignupViewModel()
                guard let portfolioData = self.viewModel.state.loginUserData.value?.portfolioList[index] else { return }
                signViewModel.state.editData.value = Item(itemInfo: ItemInfo(isInclude: true, buttonTitle: ""),
                                                          description: "",
                                                          endDate: "",
                                                          name: "",
                                                          nowWork: false,
                                                          startDate: "",
                                                          portfolioLink: portfolioData)
                self.coordinator?.showPortfolioController(self, viewModel: signViewModel)
            }
        })
        let delete = UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            if section == 0 {
                self.viewModel.action.deleteProjectData.send(index)
            } else {
                self.viewModel.action.deletePortfolioData.send(index)
            }
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

// MARK: - ConfigureTableView
extension MyBudiEditViewController {
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: MyBudiEditHeaderView.cellId, bundle: nil)
        let normal = UINib(nibName: NormalTextFieldTableViewCell.cellId, bundle: nil)
        let location = UINib(nibName: LocationReplaceTableViewCell.cellId, bundle: nil)
        let position = UINib(nibName: PositionTableViewCell.cellId, bundle: nil)
        let project = UINib(nibName: ProjectTableViewCell.cellId, bundle: nil)
        let portfolio = UINib(nibName: PortfolioURLTableViewCell.cellId, bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: MyBudiEditHeaderView.cellId)
        tableView.register(normal, forCellReuseIdentifier: NormalTextFieldTableViewCell.cellId)
        tableView.register(location, forCellReuseIdentifier: LocationReplaceTableViewCell.cellId)
        tableView.register(position, forCellReuseIdentifier: PositionTableViewCell.cellId)
        tableView.register(project, forCellReuseIdentifier: ProjectTableViewCell.cellId)
        tableView.register(portfolio, forCellReuseIdentifier: PortfolioURLTableViewCell.cellId)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
}

// MARK: - ConfigureViewController
private extension MyBudiEditViewController {
    func configureNavigationBar() {
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("저장", for: .normal)

        let stackview = UIStackView(arrangedSubviews: [saveButton])

        navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: stackview)
        title = "프로필 수정"

        saveButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.action.postUserData.send(())
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }

    func configureLayout() {
        guard let url = URL(string: viewModel.state.loginUserData.value?.imgUrl ?? "") else { return }
        userImageView.kf.setImage(with: url)
        userImageView.contentMode = .scaleAspectFill
    }

    func editUserImageAlert() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "카메라", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            let camera = UIImagePickerController()
            camera.sourceType = .camera
            camera.allowsEditing = true
            camera.cameraDevice = .rear
            camera.cameraCaptureMode = .photo
            camera.delegate = self
            self.present(camera, animated: true, completion: nil)
        })

        let album = UIAlertAction(title: "앨범", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            let album = UIImagePickerController()
            album.sourceType = .photoLibrary
            album.delegate = self
            album.allowsEditing = true

            self.present(album, animated: true, completion: nil)
        })

        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: {_ in })

        actionSheet.addAction(camera)
        actionSheet.addAction(album)
        actionSheet.addAction(cancel)

        present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - TableViewDelegate
extension MyBudiEditViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else if section == 1 {
            return (viewModel.state.loginUserData.value?.projectList.count ?? 1) + 1
        } else {
            return (viewModel.state.loginUserData.value?.portfolioList.count ?? 1) + 1
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                return 165
            } else {
                return 109
            }
        } else if indexPath.section == 1 {
            return 100
        } else {
            return 55
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 50
        }
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section >= 1 {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyBudiEditHeaderView.cellId) as? MyBudiEditHeaderView else { return UIView() }
            if section == 1 {
                header.configureHeader(header: "프로젝트 이력")
            } else {
                header.configureHeader(header: "포트폴리오")
            }
            return header
        }

        return UIView()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 || indexPath.row == 2 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: NormalTextFieldTableViewCell.cellId, for: indexPath) as? NormalTextFieldTableViewCell else { return UITableViewCell() }

                if indexPath.row == 0 {
                    cell.configureLabel(text: "닉네임")
                    cell.configureText(text: self.viewModel.state.loginUserData.value?.nickName ?? "")

                    cell.normalTextField.textPublisher
                        .receive(on: DispatchQueue.main)
                        .sink { [weak self] text in
                            guard let self = self else { return }
                            var changeData = self.viewModel.state.loginUserData.value
                            changeData?.nickName = text ?? ""
                            self.viewModel.state.loginUserData.send(changeData)
                            print(self.viewModel.state.loginUserData.value?.nickName ?? "")
                        }
                        .store(in: &cell.cancellables)
                } else {
                    cell.configureLabel(text: "한줄소개")
                    cell.configureText(text: self.viewModel.state.loginUserData.value?.description ?? "")

                    cell.normalTextField.textPublisher
                        .receive(on: DispatchQueue.main)
                        .sink { [weak self] text in
                            guard let self = self else { return }
                            var changeData = self.viewModel.state.loginUserData.value
                            changeData?.description = text ?? ""
                            print("여기 불림?")
                            self.viewModel.state.loginUserData.send(changeData)
                            print(self.viewModel.state.loginUserData.value?.description ?? "")
                        }
                        .store(in: &cell.cancellables)
                }

                return cell
            } else if indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationReplaceTableViewCell.cellId, for: indexPath) as? LocationReplaceTableViewCell else { return UITableViewCell() }
                cell.configureLocation(location: viewModel.state.loginUserData.value?.address ?? "")

                cell.replaceLocationButton.tapPublisher
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] _ in
                        guard let self = self else { return }
                        self.coordinator?.showLocationSearchViewController(self)
                    }
                    .store(in: &cell.cancellables)

                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PositionTableViewCell.cellId, for: indexPath) as? PositionTableViewCell else { return UITableViewCell() }
                cell.configurePosition(position: viewModel.state.loginUserData.value?.positions ?? [])

                cell.positionEditButton.tapPublisher
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] _ in
                        guard let self = self else { return }
                        self.coordinator?.showProjectMembersBottomViewController(self, self.viewModel)
                    }
                    .store(in: &cell.cancellables)
                return cell
            }
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectTableViewCell.cellId, for: indexPath) as? ProjectTableViewCell else { return UITableViewCell() }
            cell.configureButtonTitle(text: "프로젝트를 추가해 보세요")
            if (viewModel.state.loginUserData.value?.projectList.count ?? 1) != indexPath.row {
                let data = viewModel.state.loginUserData.value?.projectList[indexPath.row]
                if let data = data {
                    cell.configureLabel(main: data.name, date: data.startDate + " ~ " + data.endDate, sub: data.description)
                }
            }

            cell.addButton.tapPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    self.coordinator?.showProjectViewController(self, viewModel: SignupViewModel())
                    self.modalViewBackgoundOn()
                }
                .store(in: &cell.cancellables)

            cell.moreButton.tapPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    self.showActionSheet(section: 0, index: indexPath.row)
                }
                .store(in: &cell.cancellables)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PortfolioURLTableViewCell.cellId, for: indexPath) as? PortfolioURLTableViewCell else { return UITableViewCell() }
            if viewModel.state.loginUserData.value?.portfolioList.count != indexPath.row {
                let data = viewModel.state.loginUserData.value?.portfolioList[indexPath.row]
                if let data = data {
                    cell.configureParsing(url: data)
                }
            } else {
                cell.configureButtonLabel(text: "포트폴리오를 추가해 보세요")
            }

            cell.addButton.tapPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    self.coordinator?.showPortfolioController(self, viewModel: SignupViewModel())
                    self.modalViewBackgoundOn()
                }
                .store(in: &cell.cancellables)

            cell.editButton.tapPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    self.showActionSheet(section: 1, index: indexPath.row)
                }
                .store(in: &cell.cancellables)

            return cell
        }

    }

}

extension MyBudiEditViewController: HomeLocationSearchViewControllerDelegate {
    func getLocation(_ location: String) {
        // 아직 API에서 지역을 뽑아와주지 않아서 일단 대기
        var changeData = viewModel.state.loginUserData.value
        changeData?.address = location
        viewModel.state.loginUserData.send(changeData)
        tableView.reloadData()
    }

}

extension MyBudiEditViewController: ProjectMembersBottomViewControllerDelegate {
    func getRecruitingPositions(_ recruitingPositions: [RecruitingPosition]) {
        var changeData = viewModel.state.loginUserData.value
        let position = recruitingPositions.map { $0.positionName }
        changeData?.positions = position
        viewModel.state.loginUserData.send(changeData)
        tableView.reloadData()
    }

}

extension MyBudiEditViewController: HistoryWriteViewControllerDelegate {
    func getProject(_ project: SignupInfoModel?, _ editItem: Item?) {
        var changeData = viewModel.state.loginUserData.value
        let changeProject = ProjectList(projectId: 0,
                                        name: project?.mainName ?? "",
                                        startDate: project?.startDate ?? "",
                                        endDate: project?.endDate ?? "",
                                        description: project?.description ?? "")
        if editItem != nil {
            changeData?.projectList[editIndex] = changeProject
        } else {
            changeData?.projectList.append(changeProject)
        }
        viewModel.state.loginUserData.send(changeData)
        editIndex = -1
        tableView.reloadData()
    }
}

extension MyBudiEditViewController: PortfolioViewControllerDelegate {
    func getPortfolio(_ portfolio: SignupInfoModel?) {
        guard var changeData = viewModel.state.loginUserData.value else { return }
        changeData.portfolioList.append(portfolio?.porflioLink ?? "")
        viewModel.state.loginUserData.send(changeData)
        tableView.reloadData()
    }
}

// MARK: - UIImagePicker
extension MyBudiEditViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage, let jpegData = image.jpegData(compressionQuality: 0.2) else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        userImageView.image = image

        viewModel.convertImageToURL(jpegData, { result in
            switch result {
            case .success(let response):
                do {
                    guard let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any],
                          let data = json["data"] as? [String: Any],
                          let imageUrl = data["imageUrl"] as? String else { return }
                    var changeData = self.viewModel.state.loginUserData.value
                    changeData?.imgUrl = imageUrl
                    print("이미지 URL", imageUrl)
                    picker.dismiss(animated: true)
                } catch {}
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        })
    }
}
