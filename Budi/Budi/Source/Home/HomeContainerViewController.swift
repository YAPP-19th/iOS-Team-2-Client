//
//  HomeViewController.swift
//  Budi
//
//  Created by 최동규 on 2021/10/11.
//

import UIKit
import Moya
import Combine
import CombineCocoa
import SwiftUI

final class HomeContainerViewController: UIViewController {

    @IBOutlet private weak var teamAddButton: UIButton!
    @IBOutlet private weak var titleButtonStackView: UIStackView!
    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var contentScrollView: UIScrollView!

    @IBOutlet private weak var selectIndicatorView: UIView!
    @IBOutlet private weak var indicatorViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var indicatorViewLeadingConstraint: NSLayoutConstraint!
    weak var coordinator: HomeCoordinator?

    private var currentIndex: Int = 0
    private var cancellables = Set<AnyCancellable>()
    private let contentViewControllers: [HomeContentViewController]

    init?(coder: NSCoder, contentViewControllers: [HomeContentViewController]) {
        self.contentViewControllers = contentViewControllers
        if contentViewControllers.isEmpty {
            fatalError("This viewController must be init with contentViewControllers")
        }
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("This viewController must be init with contentViewControllers")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setPublisher()
        setView()
    }
}

private extension HomeContainerViewController {

    func setPublisher() {
        teamAddButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.coordinator?.showWriting()
            }.store(in: &cancellables)

        contentScrollView.didScrollPublisher
            .throttle(for: 0.05, scheduler: DispatchQueue.main, latest: true)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }

                var currentIndex = Int(self.contentScrollView.contentOffset.x / self.contentScrollView.frame.width)
                currentIndex = Int(((self.titleButtonStackView.arrangedSubviews[currentIndex].frame.width * CGFloat(self.contentViewControllers.count) / 2 ) + self.contentScrollView.contentOffset.x) / self.contentScrollView.frame.width)
                UIViewPropertyAnimator(duration: 0.2, curve: .linear) { [weak self] in
                    guard let self = self else { return }
                    self.indicatorViewWidthConstraint.constant = self.titleButtonStackView.arrangedSubviews[currentIndex].frame.width

                    self.indicatorViewLeadingConstraint.constant = CGFloat(self.contentScrollView.contentOffset.x / CGFloat(self.contentViewControllers.count))
                    self.titleButtonStackView.subviews.indices.forEach { index in
                        (self.titleButtonStackView.subviews[index] as? UIButton)?.setTitleColor(index == currentIndex ? .black : .systemGray5, for: .normal)

                    }
                    self.titleButtonStackView.layoutIfNeeded()
                    self.selectIndicatorView.superview?.layoutIfNeeded()
                }.startAnimation()

                self.currentIndex = currentIndex
            }).store(in: &cancellables)
    }
    func setView() {
        contentScrollView.isPagingEnabled = true
        contentScrollView.showsHorizontalScrollIndicator = false
        teamAddButton.tintColor = UIColor.primary
        setContentViews()
    }

    func setContentViews() {
        contentViewControllers.enumerated().forEach { (index, vc) in
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            contentStackView.addArrangedSubview(vc.view)

            let button = UIButton(type: .system)
            button.setTitle(vc.viewModel.title, for: .normal)
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.lineBreakMode = .byClipping
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)

            button.tapPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self = self, self.currentIndex != index else { return }
                    if self.currentIndex > index {
                        let tempIndex = index + 1 < self.contentViewControllers.count ? index + 1 : index
                        self.contentScrollView.setContentOffset(.init(x: CGFloat(tempIndex) * self.contentScrollView.frame.width, y: 0), animated: false)
                    } else {
                        let tempIndex = index - 1 >= 0 ? index - 1 : index
                        self.contentScrollView.setContentOffset(.init(x: CGFloat(tempIndex) * self.contentScrollView.frame.width, y: 0), animated: false)
                    }
                    self.contentScrollView.setContentOffset(.init(x: CGFloat(index) * self.contentScrollView.frame.width, y: 0), animated: true)
                }.store(in: &cancellables)
            titleButtonStackView.addArrangedSubview(button)
            NSLayoutConstraint.activate([vc.view.widthAnchor.constraint(equalTo: titleButtonStackView.widthAnchor)])

            vc.coordinator = coordinator
            addChild(vc)

        }

        indicatorViewWidthConstraint.constant = titleButtonStackView.arrangedSubviews[currentIndex].frame.width

        indicatorViewLeadingConstraint.constant = CGFloat(contentScrollView.contentOffset.x / CGFloat(contentViewControllers.count))
        titleButtonStackView.subviews.indices.forEach { index in
            (titleButtonStackView.subviews[index] as? UIButton)?.setTitleColor(index == currentIndex ? .black : .systemGray5, for: .normal)
        }
        view.layoutIfNeeded()
    }
}

private extension HomeContainerViewController {

    func configureNavigationBar() {
        let editButton = UIButton()
        editButton.setImage(.init(systemName: "line.3.horizontal"), for: .normal)

        let searchButton = UIButton()
        searchButton.setImage(.init(systemName: "magnifyingglass"), for: .normal)

        let notifyButton = UIButton()
        notifyButton.setImage(.init(systemName: "bell"), for: .normal)

        let stackview = UIStackView(arrangedSubviews: [editButton, searchButton, notifyButton])
        stackview.distribution = .equalSpacing
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 8

        navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: stackview)
        title = "버디 모집"
    }
}
