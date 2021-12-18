//
//  HomeWritingDurationBottomViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/15.
//

import UIKit
import Combine
import CombineCocoa

protocol DatePickerBottomViewControllerDelegate: AnyObject {
    func getDateFromDatePicker(_ date: Date)
}

final class DatePickerBottomViewController: UIViewController {

    @IBOutlet weak var backgroundButton: UIButton!
    @IBAction func backgroundButtonTapped(_ sender: Any) {
        hideBottomView()
    }
    
    @IBOutlet private weak var completeButton: UIButton!
    @IBAction private func completeButtonTapped(_ sender: Any) {
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet private weak var bottomViewTopConstraint: NSLayoutConstraint!
    
    private var isBottomViewShown: Bool = false
    
    weak var delegate: DatePickerBottomViewControllerDelegate?
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPublisher()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showBottomView()
    }
}

private extension DatePickerBottomViewController {
    func setPublisher() {
        datePicker.datePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                guard let self = self else { return }
                self.delegate?.getDateFromDatePicker(date)
            }.store(in: &cancellables)
    }
    
    func showBottomView() {
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear) { [weak self] in
            guard let self = self else { return }
            self.bottomViewTopConstraint.constant -= self.bottomView.bounds.height - 95
            self.view.layoutIfNeeded()
        }
        animator.addCompletion { [weak self] _ in
            self?.isBottomViewShown = true
        }
        animator.startAnimation()
    }
    
    func hideBottomView() {
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear) { [weak self] in
            guard let self = self else { return }
            self.bottomViewTopConstraint.constant += self.bottomView.bounds.height - 95
            self.view.layoutIfNeeded()
        }
        animator.addCompletion { [weak self] _ in
            self?.dismiss(animated: false, completion: nil)
            self?.isBottomViewShown = false
        }
        animator.startAnimation()
    }
}
