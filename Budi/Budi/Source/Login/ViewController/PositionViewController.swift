//
//  ConfigurePositionViewController.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/07.
//

import UIKit
import Combine
import CombineCocoa

class PositionViewController: UIViewController {
    weak var coordinator: LoginCoordinator?
    private let viewModel: SignupViewModel
    private let alertView = AlertView()
    private var cancellables = Set<AnyCancellable>()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.updateContentView()
    }

    private let progressView: ProgressView = {
        let progress = ProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.changeColor(index: 2)
        return progress
    }()

    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor.init(white: 0, alpha: 0.38)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 25, right: 0)
        button.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    @objc
    func nextAction() {
        configureAlert()

    }

    private let positionLabel: UILabel = {
        let label = UILabel()
        let bold = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24)]
        let normal = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)]
        let oneString = NSMutableAttributedString(string: "프로젝트에 ", attributes: normal)
        let twoString = NSMutableAttributedString(string: " 참여하고자하는 직무", attributes: bold)
        let threeString = NSMutableAttributedString(string: "를 선택해주세요 ☺️", attributes: normal)
        oneString.append(twoString)
        oneString.append(threeString)
        label.attributedText = oneString
        label.numberOfLines = 0
        return label
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()

    private let positionDetailCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()

    private let normalPositionView = NormalPositionView()
    private let spacingDarkView = SpacingDarkLineView()

    private let normalPositionLabel: UILabel = {
        let label = UILabel()
        label.text = "직무"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.init(white: 0, alpha: 0.8)
        return label
    }()

    private let detailPositionLabel: UILabel = {
        let label = UILabel()
        label.text = "상세 직무"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.init(white: 0, alpha: 0.8)

        return label
    }()

    private let programmingLanguageLabel: UILabel = {
        let label = UILabel()
        label.text = "개발 언어"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.init(white: 0, alpha: 0.8)

        return label
    }()

    private let spacer: SpacingDarkLineView = {
        let space = SpacingDarkLineView()
        space.backgroundColor = .white

        return space
    }()

    init?(coder: NSCoder, viewModel: SignupViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(nextButtonActivation), name: NSNotification.Name("NextButtonActivation"), object: nil)
        nextButton.isEnabled = false
        self.addBackButton()
        configureLayout()
        bindButton()
        bindViewModel()
        configureCollectionView()
    }

    private func bindButton() {
        alertView.doneButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.coordinator?.showHistoryManagementViewController()
            }
            .store(in: &cancellables)

        normalPositionView.productManagerButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.action.positionFetch.send(Position.productManager)
            }
            .store(in: &cancellables)

        normalPositionView.developerButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                print("\(Position.developer)")
                self?.viewModel.action.positionFetch.send(Position.developer)
            }
            .store(in: &cancellables)

        normalPositionView.designerButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                print("\(Position.designer)")
                self?.viewModel.action.positionFetch.send(Position.designer)
            }
            .store(in: &cancellables)

    }

    private func bindViewModel() {
        viewModel.state.positionData
            .receive(on: DispatchQueue.main)
            .sink { positionData in
                guard let data = positionData else { return }
                self.positionDetailCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }

    @objc
    func nextButtonActivation() {
        nextButton.isEnabled = true
        nextButton.backgroundColor = UIColor.budiGreen
    }

    @objc
    func positionButtionAction(sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            sender.setTitleColor(UIColor.budiGreen, for: .normal)
            sender.layer.borderColor = UIColor.budiGreen.cgColor
            UIView.animate(withDuration: 0.2, animations: {
                sender.layer.borderWidth = 2
            })
        } else {
            sender.isSelected = false
            sender.setTitleColor(UIColor.init(white: 0, alpha: 0.6), for: .normal)
            UIView.animate(withDuration: 0.2, animations: {
                sender.layer.borderWidth = 0.3
                sender.layer.borderColor = UIColor.init(white: 0, alpha: 0.6).cgColor
            })
        }
        NotificationCenter.default.post(name: NSNotification.Name("NextButtonActivation"), object: nil)
    }

    @objc
    func normalPositionButtonAction(sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            sender.setTitleColor(UIColor.budiGreen, for: .normal)
        } else {
            sender.isSelected = false
            sender.setTitleColor(UIColor.lightGray, for: .normal)
        }
    }

    @objc
    func dismissAlert() {
        UIView.animate(withDuration: 0.2, animations: {
            BackgroundView.instanceBackground.alpha = 0.0
            self.alertView.alpha = 0.0
        }, completion: nil)

    }

    private func configureCollectionView() {
        positionDetailCollectionView.register(PositionDetailCollectionViewCell.self, forCellWithReuseIdentifier: PositionDetailCollectionViewCell.cellId)
        let flow = LeftAlignedCollectionViewFlowLayout()
        positionDetailCollectionView.delegate = self
        positionDetailCollectionView.showsVerticalScrollIndicator = false
        positionDetailCollectionView.dataSource = self
        positionDetailCollectionView.collectionViewLayout = flow
    }

    private func configureAlert() {
        BackgroundView.instanceBackground.alpha = 0.0
        alertView.alpha = 0.0
        alertView.showAlert(title: "프로젝트 이력을 입력하고\n 더 높은 레벨을 받아보세요!", cancelTitle: "나중에 입력하기", doneTitle: "지금 입력하기")
        view.addSubview(BackgroundView.instanceBackground)
        BackgroundView.instanceBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            BackgroundView.instanceBackground.topAnchor.constraint(equalTo: view.topAnchor),
            BackgroundView.instanceBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            BackgroundView.instanceBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            BackgroundView.instanceBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.widthAnchor.constraint(equalToConstant: 343),
            alertView.heightAnchor.constraint(equalToConstant: 208)
        ])

        UIView.animate(withDuration: 0.2, animations: {
            BackgroundView.instanceBackground.alpha = 0.5
            self.alertView.alpha = 1.0
        })
    }

    private func configureLayout() {
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 83).isActive = true

        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: nextButton.topAnchor)
        ])

        scrollView.addSubview(positionLabel)
        positionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            positionLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            positionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            positionLabel.heightAnchor.constraint(equalToConstant: 64),
            positionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -98)
        ])

        scrollView.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: positionLabel.bottomAnchor, constant: 21),
            progressView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            progressView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 77)
        ])

        scrollView.addSubview(spacingDarkView)
        spacingDarkView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            spacingDarkView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 20),
            spacingDarkView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            spacingDarkView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            spacingDarkView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            spacingDarkView.heightAnchor.constraint(equalToConstant: 8)
        ])

        scrollView.addSubview(normalPositionLabel)
        normalPositionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            normalPositionLabel.topAnchor.constraint(equalTo: spacingDarkView.topAnchor, constant: 20),
            normalPositionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16)
        ])

        scrollView.addSubview(normalPositionView)
        normalPositionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            normalPositionView.topAnchor.constraint(equalTo: normalPositionLabel.bottomAnchor),
            normalPositionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            normalPositionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            normalPositionView.heightAnchor.constraint(equalToConstant: 150)
        ])

        scrollView.addSubview(detailPositionLabel)
        detailPositionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            detailPositionLabel.topAnchor.constraint(equalTo: normalPositionView.bottomAnchor),
            detailPositionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16)
        ])

        scrollView.addSubview(positionDetailCollectionView)
        positionDetailCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            positionDetailCollectionView.topAnchor.constraint(equalTo: detailPositionLabel.bottomAnchor, constant: 16),
            positionDetailCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            positionDetailCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            positionDetailCollectionView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
}

extension PositionViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let data = viewModel.state.positionData.value?.count else { return 0 }
        return data
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PositionDetailCollectionViewCell.cellId, for: indexPath) as? PositionDetailCollectionViewCell else { return .zero }
        guard let text = viewModel.state.positionData.value?[indexPath.row] else { return CGSize() }

        cell.configureButtonText(text)
        cell.positionDetailButton.sizeToFit()
        let cellWidth = cell.positionDetailButton.frame.width

        return CGSize(width: cellWidth, height: 32)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PositionDetailCollectionViewCell.cellId, for: indexPath) as? PositionDetailCollectionViewCell else { return UICollectionViewCell() }
        guard let text = viewModel.state.positionData.value?[indexPath.row] else { return UICollectionViewCell() }

        cell.configureButtonText(text)

        cell.positionDetailButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                cell.positionDetailButton.isSelected = !cell.positionDetailButton.isSelected
                print(indexPath.row)
                if cell.positionDetailButton.isSelected {
                    self.viewModel.action.positionSelect.send(text)
                } else {
                    self.viewModel.action.positionDeSelect.send(text)
                }

                cell.positionDetailButton.layer.borderColor = cell.positionDetailButton.isSelected ? UIColor.budiGreen.cgColor : UIColor.budiGray.cgColor
                self.nextButton.isEnabled = true
                self.nextButton.backgroundColor = UIColor.budiGreen
            }
            .store(in: &cell.cancellables)

        return cell

    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        print(indexPath.row)

        return true
    }
    
}
