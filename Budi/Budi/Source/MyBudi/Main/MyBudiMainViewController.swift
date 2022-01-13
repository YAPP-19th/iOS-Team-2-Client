//
//  MyBudiMainViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/21.
//

import UIKit
import Combine
import CombineCocoa

final class MyBudiMainViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    @IBOutlet weak var loginButton: UIButton!
    weak var coordinator: MyBudiCoordinator?
    private let viewModel: MyBudiMainViewModel
    private var cancellables = Set<AnyCancellable>()

    init(nibName: String?, bundle: Bundle?, viewModel: MyBudiMainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.action.loadProjectStatus.send(())
        loginStatusCheck()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCollectionView()
        setPublisher()
        self.viewModel.action.LoginStatusCheck.send(())

        bindViewModel()
    }

    func loginStatusCheck() {
        if UserDefaults.standard.string(forKey: "accessToken") == "" {
            collectionView.isHidden = true
        } else {
            collectionView.isHidden = false
        }
    }

    private func bindViewModel() {
        viewModel.state.loginStatusData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self = self else { return }
                if UserDefaults.standard.string(forKey: "accessToken") == "" {
                    self.collectionView.isHidden = true
                } else {
                    self.collectionView.isHidden = false
                    self.collectionView.reloadData()
                }
            }
            .store(in: &cancellables)

        viewModel.state.likedData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self = self else { return }
                self.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }

    private func setPublisher() {

        NotificationCenter.default.publisher(for: Notification.Name("LoginSuccessed"), object: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.action.LoginStatusCheck.send(())
                self.viewModel.action.loadProjectStatus.send(())
            }
            .store(in: &cancellables)

        loginButton.tapPublisher
            .sink { _ in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginSelectViewController = storyboard.instantiateViewController(identifier: "LoginSelectViewController")
                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                sceneDelegate?.moveLoginController(loginSelectViewController, animated: true)
            }
            .store(in: &cancellables)
    }
}

// MARK: - CollectionView
extension MyBudiMainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func configureCollectionView() {
        MyBudiMainCellType.configureCollectionView(self, collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        MyBudiMainCellType.numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        MyBudiMainCellType.configureCellSize(collectionView, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        MyBudiMainCellType.minimumLineSpacingForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let defaultCell = UICollectionViewCell()
        let loginData = viewModel.state.loginStatusData.value
        let likedData = viewModel.state.likedData.value
        let projectData = viewModel.state.projectData.value
        switch indexPath.row {

        case 0: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyBudiProfileCell.identifier, for: indexPath) as? MyBudiProfileCell else { return defaultCell }
            if loginData?.positions.count != 0 {
                cell.setUserData(nickName: loginData?.nickName ?? "로딩중", position: loginData?.positions[0] ?? "로딩중", description: loginData?.description ?? "임시소개글")
            } else {
                cell.setUserData(nickName: loginData?.nickName ?? "로딩중", position: "임시글", description: loginData?.description ?? "임시소개글")
            }

            cell.configureUserImage(url: viewModel.state.loginStatusData.value?.imgUrl ?? "", basePosition: viewModel.state.loginStatusData.value?.basePosition ?? 1)

            cell.editButton.tapPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    self.coordinator?.showEditViewController(userData: self.viewModel.state.loginStatusData.value ?? nil)
                }.store(in: &cell.cancellables)
            return cell
            
        case 1: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyBudiLevelCell.identifier, for: indexPath) as? MyBudiLevelCell else { return defaultCell }

            cell.setLevel(level: loginData?.level ?? "")

            return cell
            
        case 2: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyBudiProjectCell.identifier, for: indexPath) as? MyBudiProjectCell else { return defaultCell }

            cell.setProjectLabels(nowProject: projectData?.participatedPosts.count ?? 0, recruit: projectData?.recruitedPosts.count ?? 0, liked: likedData?.totalElements ?? 0)

            return cell
            
        case 3: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyBudiHelpCell.identifier, for: indexPath) as? MyBudiHelpCell else { return defaultCell }

            cell.logoutButton.tapPublisher
                .sink { _ in
                    UserDefaults.standard.set("", forKey: "accessToken")
                    UserDefaults.standard.set(0, forKey: "memberId")
                    self.collectionView.isHidden = true
                    self.view.reloadInputViews()
                }
                .store(in: &cell.cancellables)
            return cell
            
        default: break
        }
        
        return defaultCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            coordinator?.showLevelViewController(viewModel: self.viewModel)
        } else if indexPath.row == 2 {
            coordinator?.showProjectDetailVeiwController(viewModel: self.viewModel)
        }
    }
}

private extension MyBudiMainViewController {
    func configureNavigationBar() {
        let notifyButton = UIButton()
        notifyButton.setImage(.init(systemName: "bell"), for: .normal)

        let stackview = UIStackView(arrangedSubviews: [notifyButton])

        navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: stackview)
        title = "나의 버디"
    }
}
