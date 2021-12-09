//
//  BottomSheetViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit
import Combine
import CombineCocoa

class BottomSheetViewController: UIViewController {

    @IBOutlet weak var bottomSheetView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    private var isBottonSheetShown: Bool = false
    private var isHeartButtonChecked: Bool = false
    private var selectedRecruitingStatus: RecruitingStatus?
    
    weak var coordinator: HomeCoordinator?
    private let viewModel: HomeDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(nibName: String?, bundle: Bundle?, viewModel: HomeDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setPublisher()
        bindViewModel()
    }
}

private extension BottomSheetViewController {
    func setPublisher() {
        submitButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                    guard let self = self else { return }
                    self.showBottomSheetView()
                }, completion: nil)
            }.store(in: &cancellables)

        heartButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.isHeartButtonChecked.toggle()
                self.heartButton.setImage(UIImage(systemName: self.isHeartButtonChecked ? "heart.fill" : "heart"), for: .normal)
                self.heartButton.tintColor = self.isHeartButtonChecked ? UIColor.budiGreen : UIColor.budiGray
            }.store(in: &cancellables)
        
        closeButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                    guard let self = self else { return }
                    self.showBottomSheetView()
                }, completion: { _ in
                    self.dismiss(animated: true, completion: nil)
                })
            }.store(in: &cancellables)
    }
    
    func showBottomSheetView() {
        let cellHeight: CGFloat = 64
        let cellCount: Int = self.viewModel.state.recruitingStatuses.value.count
        
        if isBottonSheetShown {
            bottomSheetView.center.y += (bottomSheetView.bounds.height - cellHeight * CGFloat((4 - cellCount)))
            isBottonSheetShown = false
        } else {
            bottomSheetView.center.y -= (bottomSheetView.bounds.height - cellHeight * CGFloat((4 - cellCount)))
            isBottonSheetShown = true
        }
    }
    
    func bindViewModel() {
    }
    
    func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(.init(nibName: BottomSheetCell.identifier, bundle: nil), forCellWithReuseIdentifier: BottomSheetCell.identifier)
    }
}

extension BottomSheetViewController: BottomSheetCellDelegate {
    func selectBottomSheetCell(_ recruitingStatus: RecruitingStatus) {
        print(recruitingStatus.positionName)
        selectedRecruitingStatus = recruitingStatus
    }
}

extension BottomSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.state.recruitingStatuses.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomSheetCell.identifier, for: indexPath) as? BottomSheetCell else { return UICollectionViewCell() }
        cell.delegate = self
        cell.recruitingStatus = viewModel.state.recruitingStatuses.value[indexPath.row]
        return cell
    }
}

extension BottomSheetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 56)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}
