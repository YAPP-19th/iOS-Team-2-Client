//
//  HomeWritingViewController.swift
//  Budi

//  Created by leeesangheee on 2021/10/11.
//
import UIKit
import Combine
import CombineCocoa

final class HomeWritingViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var completeButton: UIButton!
    
    private var isStartDate: Bool = true
    
    weak var coordinator: HomeCoordinator?
    private let viewModel: HomeWritingViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init?(coder: NSCoder, viewModel: HomeWritingViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("This viewController must be init with viewModel")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setPublisher()
        configureNavigationBar()
        configureCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}

private extension HomeWritingViewController {
    func bindViewModel() {
        viewModel.state.selectedImageUrl
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.collectionView.reloadData()
            }).store(in: &cancellables)
        
        viewModel.state.defaultImageUrls
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.collectionView.reloadData()
            }).store(in: &cancellables)
    }
    
    func setPublisher() {
        completeButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self,
                      let imageUrl = self.viewModel.state.selectedImageUrl.value,
                      let title = self.viewModel.state.name.value,
                      let categoryName = self.viewModel.state.part.value,
                      let startDate = self.viewModel.state.startDate.value,
                      let endDate = self.viewModel.state.endDate.value,
                      let isOnline = self.viewModel.state.isOnline.value,
                      let region = self.viewModel.state.area.value,
                      !self.viewModel.state.recruitingPositions.value.isEmpty,
                      let description = self.viewModel.state.description.value else { return }
                
                let recruitingPositions = self.viewModel.state.recruitingPositions.value
                
                let param = PostRequest(imageUrl: imageUrl,
                                        title: title,
                                        categoryName: categoryName,
                                        startDate: startDate.convertStringyyyyMMddTHHmmSS(),
                                        endDate: endDate.convertStringyyyyMMddTHHmmSS(),
                                        onlineInfo: isOnline ? "온라인" : "오프라인",
                                        region: region,
                                        recruitingPositions: recruitingPositions,
                                        description: description)
                
                self.viewModel.createPost(.testAccessToken, param) { result in
                    switch result {
                    case .success(let response): break
                    case .failure(let error): print("error is \(error.localizedDescription)")
                    }
                }
                self.navigationController?.popViewController(animated: true)
            }.store(in: &cancellables)
    }
    
    func isValid() {
        guard viewModel.state.selectedImageUrl.value != nil,
              viewModel.state.name.value != nil,
              viewModel.state.part.value != nil,
              viewModel.state.startDate.value != nil,
              viewModel.state.endDate.value != nil,
              viewModel.state.isOnline.value != nil,
              viewModel.state.area.value != nil,
              !viewModel.state.recruitingPositions.value.isEmpty,
              viewModel.state.description.value != nil else { return }
        
        completeButton.isEnabled = true
        completeButton.backgroundColor = .primary
    }
    
    func configureNavigationBar() {
        title = "팀원 모집"
        tabBarController?.tabBar.isHidden = true
    }
}

// MARK: - Delegate
extension HomeWritingViewController: HomeWritingImageBottomViewControllerDelegate {
    func getImageUrlString(_ urlString: String) {
        viewModel.state.selectedImageUrl.value = urlString
        collectionView.reloadData()
        isValid()
    }
}

extension HomeWritingViewController: HomeWritingNameCellDelegate {
    func changeName(_ name: String) {
        viewModel.state.name.value = name
        isValid()
    }
}

extension HomeWritingViewController: HomeWritingPartBottomViewControllerDelegate {
    func getPart(_ part: String) {
        viewModel.state.part.value = part
        collectionView.reloadData()
        isValid()
    }
}

extension HomeWritingViewController: HomeWritingDurationCellDelegate {
    func showDatePickerBottomView(_ isStartDate: Bool) {
        self.isStartDate = isStartDate
        let limitDate: Date? = isStartDate ? viewModel.state.endDate.value : viewModel.state.startDate.value
        coordinator?.showDatePickerViewController(self, isStartDate, limitDate)
        isValid()
    }}

extension HomeWritingViewController: DatePickerBottomViewControllerDelegate {
    func getDateFromDatePicker(_ date: Date) {
        if isStartDate {
            viewModel.state.startDate.value = date
        } else {
            viewModel.state.endDate.value = date
        }
        collectionView.reloadData()
        isValid()
    }
}

extension HomeWritingViewController: HomeWritingOnlineCellDelegate {
    func changeOnline(_ isOnline: Bool) {
        viewModel.state.isOnline.value = isOnline
        collectionView.reloadData()
        isValid()
    }
}

extension HomeWritingViewController: HomeLocationSearchViewControllerDelegate {
    func getLocation(_ location: String) {
        viewModel.state.area.value = location
        collectionView.reloadData()
        isValid()
    }
}

extension HomeWritingViewController: HomeWritingMembersBottomViewControllerDelegate {
    func getRecruitingPositions(_ recruitingPositions: [RecruitingPosition]) {
        viewModel.state.recruitingPositions.value = recruitingPositions
        collectionView.reloadData()
        isValid()
    }
}

extension HomeWritingViewController: HomeWritingDescriptionCellDelegate {
    func changeDescription(_ description: String) {
        viewModel.state.description.value = description
        isValid()
    }
}

// MARK: - CollectionView
extension HomeWritingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func configureCollectionView() {
        HomeWritingCellType.configureCollectionView(self, collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        HomeWritingCellType.numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        HomeWritingCellType.configureCellSize(collectionView, indexPath, viewModel.state.recruitingPositions.value.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        HomeWritingCellType.minimumLineSpacingForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()

        switch indexPath.row {
    
        case 0: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingImageCell.identifier, for: indexPath) as? HomeWritingImageCell else { return cell }
            if let url = viewModel.state.selectedImageUrl.value {
                cell.configureUI(url)
            } else {
                let ramdomNumber = Int(arc4random_uniform(9))
                let defaultImageUrls = viewModel.state.defaultImageUrls.value
                if defaultImageUrls.count >= 9 {
                    let randomUrl = defaultImageUrls[ramdomNumber]
                    viewModel.state.selectedImageUrl.value = randomUrl
                    cell.configureUI(randomUrl)
                }
            }
            cell.imageChangeButton.tapPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    self.coordinator?.showWritingImageBottomViewController(self, self.viewModel)
                }.store(in: &cancellables)
            return cell
            
        case 1: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingNameCell.identifier, for: indexPath) as? HomeWritingNameCell else { return cell }
            cell.delegate = self
            return cell
            
        case 2: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingPartCell.identifier, for: indexPath) as? HomeWritingPartCell else { return cell }
            if let part = viewModel.state.part.value {
                cell.configureUI(part)
            }
            cell.selectPartButton.tapPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    self.coordinator?.showWritingPartBottomViewController(self, self.viewModel)
                }.store(in: &cell.cancellables)
            return cell
            
        case 3: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingDurationCell.identifier, for: indexPath) as? HomeWritingDurationCell else { return cell }
            cell.delegate = self
            cell.configureUI(viewModel.state.startDate.value, viewModel.state.endDate.value)
            return cell
            
        case 4: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingOnlineCell.identifier, for: indexPath) as? HomeWritingOnlineCell else { return cell }
            cell.delegate = self
            return cell
            
        case 5: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingAreaCell.identifier, for: indexPath) as? HomeWritingAreaCell else { return cell }
            if let area = viewModel.state.area.value {
                cell.configureUI(area)
            }
            cell.selectButton.tapPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    self.coordinator?.showLocationSearchViewController(self)
                }.store(in: &cell.cancellables)
            return cell
            
        case 6: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingMembersCell.identifier, for: indexPath) as? HomeWritingMembersCell else { return cell }
            cell.recruitingPositions = viewModel.state.recruitingPositions.value
            cell.addButton.tapPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    self.coordinator?.showWritingMembersBottomViewController(self, self.viewModel)
                }.store(in: &cell.cancellables)
            return cell
            
        case 7: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingDescriptionCell.identifier, for: indexPath) as? HomeWritingDescriptionCell else { return cell }
            cell.delegate = self
            return cell
            
        default: break
        }
        
        return cell
    }
}
