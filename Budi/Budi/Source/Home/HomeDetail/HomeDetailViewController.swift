//
//  HomeDetailViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/02.
//

import UIKit
import Moya
import Combine
import CombineCocoa

final class HomeDetailViewController: UIViewController {

    @IBOutlet private weak var mainCollectionView: UICollectionView!
    @IBOutlet private weak var backgroundView: UIView!

    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var heartButton: UIButton!
    @IBOutlet private weak var heartCountLabel: UILabel!
    @IBOutlet private weak var submitButton: UIButton!

    private var isHeartButtonChecked: Bool = false

    weak var coordinator: HomeCoordinator?
    private let viewModel: HomeDetailViewModel
    private var cancellables = Set<AnyCancellable>()

    init?(coder: NSCoder, viewModel: HomeDetailViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("This viewController must be init with viewModel")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.layer.addBorderTop()
        configureNavigationBar()
        configureCollectionView()
        bindViewModel()
        setPublisher()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.setTranslucent()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.removeTranslucent()
    }
}

private extension HomeDetailViewController {
    func bindViewModel() {
        viewModel.state.post
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in
                self?.mainCollectionView.reloadData()
            }, receiveValue: { _ in
                self.mainCollectionView.reloadData()
            }).store(in: &cancellables)
    }
    
    func setPublisher() {
        heartButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.isHeartButtonChecked.toggle()
                self.heartButton.setImage(UIImage(systemName: self.isHeartButtonChecked ? "heart.fill" : "heart"), for: .normal)
                self.heartButton.tintColor = self.isHeartButtonChecked ? UIColor.budiGreen : UIColor.budiGray
            }.store(in: &cancellables)

        submitButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.coordinator?.showRecruitingStatusBottomViewController(self, self.viewModel)
            }.store(in: &cancellables)
    }
}

private extension HomeDetailViewController {
    func configureNavigationBar() {
        let actionButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonTapped))
        navigationItem.rightBarButtonItem = actionButton
        navigationController?.navigationBar.tintColor = .systemGray
    }

    @objc
    func actionButtonTapped() {
        let alert = GreetingAlertViewController()
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Delegate
extension HomeDetailViewController: RecruitingStatusBottomViewControllerDelegate {
    func getSelectedRecruitingStatus(_ selectedRecruitingStatus: RecruitingStatus) {
        let param = AppliesRequest(postId: 11, recruitingPositionId: selectedRecruitingStatus.recruitingPositionId)
        
        let testAccessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJFeHBpcmVkUGVyaW9kIjoiMzYwMCIsInVzZXJJZCI6ImFhZGEyIiwiaXNzdWVyIjoiU1lKX0lTU1VFIiwibWVtYmVySWQiOjEsImV4cCI6MTY3MDQyMTM3MH0.LkYIbZwO3zrtvDqgxNFe6IxtKovBGgu28t3g_8zS7DY"
        
        viewModel.provider.request(.applies(accessToken: testAccessToken, param: param)) { response in
            switch response {
            case .success(let result):
                print(result)
                self.dismiss(animated: false, completion: {
                    self.coordinator?.showGreetingAlertViewController(self)
                })
            case .failure(let error):
                print(error.localizedDescription)
                self.dismiss(animated: false, completion: {
                    self.coordinator?.showGreetingAlertViewController(self)
                })
            }
        }
    }
}

// MARK: - CollectionView
extension HomeDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func configureCollectionView() {
        HomeDetailCellType.configureCollectionView(self, mainCollectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        HomeDetailCellType.numberOfItemsInSection
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        HomeDetailCellType.configureCell(collectionView, indexPath, viewModel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        HomeDetailCellType.configureCellSize(collectionView, indexPath, viewModel)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        HomeDetailCellType.minimumLineSpacingForSection
    }
}
