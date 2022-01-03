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
            .sink(receiveValue: { [weak self] _ in
                self?.configureHeartButton()
                self?.configureSubmitButton()
                self?.mainCollectionView.reloadData()
            }).store(in: &cancellables)
    }
    
    func setPublisher() {
        submitButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.coordinator?.showRecruitingStatusBottomViewController(self, self.viewModel)
                self.viewModel.state.post.value?.isAlreadyApplied = true
            }.store(in: &cancellables)
        
        heartButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.requestLikePost(TEST_ACCESS_TOKEN) { response in
                    switch response {
                    case .success:
                        guard let isLiked = self.viewModel.state.post.value?.isLiked else { return }
                        self.heartButton.setImage(UIImage(systemName: isLiked ? "heart.fill" : "heart"), for: .normal)
                        self.heartButton.tintColor = isLiked ? UIColor.primary : UIColor.textDisabled
                    case .failure(let error): print(error.localizedDescription)
                    }
                }
            }.store(in: &cancellables)
    }
}

private extension HomeDetailViewController {
    func configureNavigationBar() {
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        navigationItem.rightBarButtonItem = shareButton
        navigationController?.navigationBar.tintColor = .systemGray
    }

    @objc
    func shareButtonTapped() {
        print("버디 모집 공유")
    }
    
    func configureHeartButton() {
        guard let likeCount = viewModel.state.post.value?.likeCount, let isLiked = viewModel.state.post.value?.isLiked else { return }
        heartCountLabel.text = "\(likeCount)"
        heartButton.setImage(UIImage(systemName: isLiked ? "heart.fill" : "heart"), for: .normal)
        heartButton.tintColor = isLiked ? UIColor.primary : UIColor.textDisabled
    }
    
    func configureSubmitButton() {
        guard let isAlreadyApplied = viewModel.state.post.value?.isAlreadyApplied else { return }
        if isAlreadyApplied {
            submitButton.isEnabled = false
            submitButton.setTitle("지원완료", for: .normal)
            submitButton.backgroundColor = .textDisabled
        }
    }
}

// MARK: - Delegate
extension HomeDetailViewController: RecruitingStatusBottomViewControllerDelegate {
    func getSelectedRecruitingStatus(_ selectedRecruitingStatus: RecruitingStatus) {
        let postId = viewModel.state.postId.value
        
        let param = AppliesRequest(postId: postId, recruitingPositionId: selectedRecruitingStatus.recruitingPositionId)
        
        viewModel.requestApplies(TEST_ACCESS_TOKEN, param) { result in
            switch result {
            case .success(let response):
                print("response is \(response)")
                self.dismiss(animated: false) {
                    self.coordinator?.showGreetingAlertViewController(self)
                }
            case .failure(let error):
                print(error.localizedDescription)
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
