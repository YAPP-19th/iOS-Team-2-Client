//
//  MyBudiProjectDetailViewController.swift
//  Budi
//
//  Created by 인병윤 on 2022/01/09.
//

import UIKit
import Combine
import CombineCocoa

class MyBudiProjectDetailViewController: UIViewController {
    weak var coordinator: MyBudiCoordinator?
    private var currentIndex: Int = 0
    private let contentViewControllers: [MyBudiContentViewController]
    private var cancellables = Set<AnyCancellable>()

    @IBOutlet weak var titleButtonStackView: UIStackView!
    @IBOutlet weak var selectIndicatorView: UIView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var contentStackView: UIStackView!
    
    @IBOutlet weak var indicatorViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorViewLeadingConstraint: NSLayoutConstraint!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    init?(coder: NSCoder, contentViewControllers: [MyBudiContentViewController]) {
        self.contentViewControllers = contentViewControllers
        if contentViewControllers.isEmpty {
            fatalError("This viewController must be init with contentViewControllers")
        }
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setPublisher()
        setView()
    }

}

private extension MyBudiProjectDetailViewController {

    func setPublisher() {
        contentScrollView.didScrollPublisher
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }

                var currentIndex = Int(self.contentScrollView.contentOffset.x / self.contentScrollView.frame.width)
                currentIndex = Int(((self.titleButtonStackView.arrangedSubviews[currentIndex].frame.width * CGFloat(self.contentViewControllers.count) / 2 ) + self.contentScrollView.contentOffset.x) / self.contentScrollView.frame.width)
                UIViewPropertyAnimator(duration: 0.2, curve: .linear) { [weak self] in
                    guard let self = self else { return }
                    self.indicatorViewWidthConstraint.constant =  self.titleButtonStackView.frame.width / CGFloat(self.contentViewControllers.count)

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
            button.setTitleColor(UIColor.black, for: .normal)
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
