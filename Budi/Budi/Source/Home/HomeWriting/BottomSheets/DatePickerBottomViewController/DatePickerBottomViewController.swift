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

    @IBOutlet private weak var backgroundButton: UIButton!
    @IBOutlet private weak var completeButton: UIButton!
    
    @IBOutlet private weak var datePicker: UIDatePicker!
    
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var bottomViewTopConstraint: NSLayoutConstraint!
    
    private var isBottomViewShown: Bool = false
    private var isDateSelected: Bool = false
    private var date: Date? {
        didSet {
            if isDateSelected {
                completeButton.isEnabled = true
                completeButton.backgroundColor = .primary
            }
        }
    }
    
    weak var delegate: DatePickerBottomViewControllerDelegate?
    private var cancellables = Set<AnyCancellable>()
    var isStartDate: Bool
    var limitDate: Date?
    
    init(nibName: String?, bundle: Bundle?, isStartDate: Bool, limitDate: Date?) {
        self.isStartDate = isStartDate
        self.limitDate = limitDate
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPublisher()
        datePicker.minimumDate = Date()
        if let limitDate = limitDate {
            switch isStartDate {
            case true: datePicker.maximumDate = limitDate
            case false: datePicker.minimumDate = limitDate
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomView()
    }
}

private extension DatePickerBottomViewController {
    func setPublisher() {
        datePicker.datePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                guard let self = self else { return }
                self.date = date
                self.isDateSelected = true
            }.store(in: &cancellables)
        
        completeButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                guard let self = self, let date = self.date else { return }
                self.delegate?.getDateFromDatePicker(date)
                self.hideBottomView()
            }.store(in: &cancellables)
        
        backgroundButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                self?.hideBottomView()
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
