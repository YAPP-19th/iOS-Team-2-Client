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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCollectionView()
        setPublisher()
        self.viewModel.action.LoginStatusCheck.send(())
    }

    private func setPublisher() {
        loginButton.tapPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                UserDefaults.standard.set(true, forKey: "isSwitch")
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
        
        switch indexPath.row {
            
        case 0: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyBudiProfileCell.identifier, for: indexPath) as? MyBudiProfileCell else { return defaultCell }
            cell.editButton.tapPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    self.coordinator?.showEditViewController()
                }.store(in: &cancellables)
            return cell
            
        case 1: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyBudiLevelCell.identifier, for: indexPath) as? MyBudiLevelCell else { return defaultCell }
            return cell
            
        case 2: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyBudiProjectCell.identifier, for: indexPath) as? MyBudiProjectCell else { return defaultCell }
            return cell
            
        case 3: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyBudiHelpCell.identifier, for: indexPath) as? MyBudiHelpCell else { return defaultCell }

            cell.logoutButton.tapPublisher
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    UserDefaults.standard.removeObject(forKey: "accessToken")
                }
                .store(in: &cancellables)
            return cell
            
        default: break
        }
        
        return defaultCell
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
