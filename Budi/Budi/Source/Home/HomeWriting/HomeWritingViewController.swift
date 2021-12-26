//
//  HomeWritingViewController.swift
//  Budi
//
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
        configureNavigationBar()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
}

private extension HomeWritingViewController {
    func configureNavigationBar() {
        title = "팀원 모집"
        tabBarController?.tabBar.isHidden = true
    }
}

// MARK: - Delegate
extension HomeWritingViewController: HomeWritingImageBottomViewControllerDelegate {
    func getImageUrlString(_ urlString: String) {
        print("urlString is \(urlString)")
        viewModel.state.selectedImageUrl.value = urlString
        collectionView.reloadData()
    }
}

extension HomeWritingViewController: HomeWritingNameCellDelegate {
    func changeName(_ name: String) {
        print("name is \(name)")
        viewModel.state.name.value = name
    }
}

extension HomeWritingViewController: HomeWritingPartBottomViewControllerDelegate {
    func getPart(_ part: String) {
        print("part is \(part)")
        viewModel.state.part.value = part
        collectionView.reloadData()
    }
}

extension HomeWritingViewController: HomeWritingDurationCellDelegate {
    func showDatePickerBottomView(_ isStartDate: Bool) {
        print(isStartDate ? "isStartDate" : "isEndDate")
        self.isStartDate = isStartDate
        coordinator?.showDatePickerViewController(self)
    }}

extension HomeWritingViewController: DatePickerBottomViewControllerDelegate {
    func getDateFromDatePicker(_ date: Date) {
        print("date is \(date)")
        if isStartDate {
            viewModel.state.startDate.value = date
        } else {
            viewModel.state.endDate.value = date
        }
        collectionView.reloadData()
    }
}

extension HomeWritingViewController: HomeWritingOnlineCellDelegate {
    func changeOnline(_ isOnline: Bool) {
        print("isOnline is \(isOnline)")
        viewModel.state.isOnline.value = isOnline
        collectionView.reloadData()
    }
}

extension HomeWritingViewController: LocationSearchViewControllerDelegate {
    func getLocation(_ location: String) {
        print("location is \(location)")
        viewModel.state.area.value = location
        collectionView.reloadData()
    }
}

extension HomeWritingViewController: HomeWritingMembersCellDelegate {
    func showWritingMembersBottomView() {
        coordinator?.showWritingMembersBottomViewController(self, viewModel)
    }
}

extension HomeWritingViewController: HomeWritingDescriptionCellDelegate {
    func changeDescription(_ description: String) {
        print("description is \(description)")
        viewModel.state.description.value = description
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
        HomeWritingCellType.configureCellSize(collectionView, indexPath)
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
                }.store(in: &cancellables)
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
                }.store(in: &cancellables)
            return cell
            
        case 6: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingMembersCell.identifier, for: indexPath) as? HomeWritingMembersCell else { return cell }
            cell.delegate = self
            return cell
            
        case 7: guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWritingDescriptionCell.identifier, for: indexPath) as? HomeWritingDescriptionCell else { return cell }
            cell.delegate = self
            return cell
            
        default: break
        }
        
        return cell
    }
}
