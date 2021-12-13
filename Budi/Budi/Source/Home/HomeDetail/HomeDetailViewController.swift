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

    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var backgroundView: UIView!

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var heartCountLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!

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
        configureNavigationBar()
        configureCollectionView()
        bottomView.layer.addBorderTop()
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
                self.coordinator?.showDetailBottomView(self, self.viewModel)
            }.store(in: &cancellables)
    }

    func bindViewModel() {
        viewModel.state.post
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in
                self?.mainCollectionView.reloadData()
            }, receiveValue: { _ in
                self.mainCollectionView.reloadData()
            }).store(in: &cancellables)
    }

    func configureCollectionView() {
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        
        HomeDetailCellType.allCases.forEach {
            mainCollectionView.register(.init(nibName: $0.type.identifier, bundle: nil), forCellWithReuseIdentifier: $0.type.identifier)
        }
    }
}

extension HomeDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        HomeDetailCellType.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        HomeDetailCellType.getCell(collectionView, indexPath, viewModel)
    }
}

extension HomeDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: collectionView.frame.width, height: 0)

        let cellType = HomeDetailCellType(rawValue: indexPath.row)
        size.height = cellType?.height ?? 0

        if indexPath.row == 4 {
            size.height = 64 + (99 + 8) * CGFloat(viewModel.state.teamMembers.value.count) + 64
        }

        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
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
