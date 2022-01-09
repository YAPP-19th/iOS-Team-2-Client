//
//  ChattingDetailViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit
import Combine

final class ChattingDetailViewController: UIViewController {

    @IBOutlet private weak var collecitonView: UICollectionView!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var textFieldContainerView: UIView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var sendButton: UIButton!

    private var textMessage: String = ""
    private var keyboardHeight: CGFloat?
    private var isKeyboardShown: Bool = false
    
    weak var coordinator: ChattingCoordinator?
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTabBar()
        configureTextField()
        configureKeyboardHeight()
        
        bindViewModel()
        setPublisher()
        configureCollectionView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
}

private extension ChattingDetailViewController {
    func bindViewModel() {
    }
    
    func setPublisher() {
        sendButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.sendMessage()
            }.store(in: &cancellables)
        
        textFieldContainerView.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                if !self.isKeyboardShown {
                    self.showTextField()
                }
            }.store(in: &cancellables)
    }
    
    func configureNavigationBar() {
        let ellipsisButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: nil)
        ellipsisButton.tintColor = .black

        navigationItem.rightBarButtonItem = ellipsisButton
        title = "킬러베어"
    }

    func configureTabBar() {
        tabBarController?.tabBar.isHidden = true
    }
}

// MARK: - TextField
extension ChattingDetailViewController: UITextFieldDelegate {
    private func sendMessage() {
        print("textMessage is \(self.textMessage)")
        self.textMessage = ""
        self.textField.text = ""
    }
    
    private func configureTextField() {
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(
            _:)), for: .editingChanged)
    }
    
    private func showTextField() {
        self.isKeyboardShown = true
        self.textField.becomeFirstResponder()
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear) { [weak self] in
            guard let self = self else { return }
            self.bottomViewBottomConstraint.constant = (self.keyboardHeight ?? 0) - 23
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    private func hideTextField() {
        self.isKeyboardShown = false
        self.textField.becomeFirstResponder()
        self.textField.endEditing(true)
        self.textField.resignFirstResponder()
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear) { [weak self] in
            guard let self = self else { return }
            self.bottomViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            textMessage = text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        hideTextField()
        sendMessage()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
        showTextField()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
//        hideTextField()
    }
    
    func configureKeyboardHeight() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard keyboardHeight == nil else { return }
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
    }
}

// MARK: - CollectionView
extension ChattingDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    private func configureCollectionView() {
        collecitonView.dataSource = self
        collecitonView.delegate = self
        collecitonView.register(.init(nibName: ChattingMessageCell.identifier, bundle: nil), forCellWithReuseIdentifier: ChattingMessageCell.identifier)
        collecitonView.register(.init(nibName: ChattingProjectRequestCell.identifier, bundle: nil), forCellWithReuseIdentifier: ChattingProjectRequestCell.identifier)
        collecitonView.register(.init(nibName: MyChattingMessageCell.identifier, bundle: nil), forCellWithReuseIdentifier: MyChattingMessageCell.identifier)
        collecitonView.register(.init(nibName: ChattingTimeCell.identifier, bundle: nil), forCellWithReuseIdentifier: ChattingTimeCell.identifier)
        collecitonView.alwaysBounceVertical = true
        collecitonView.backgroundColor = .systemGroupedBackground
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChattingTimeCell.identifier, for: indexPath) as? ChattingTimeCell else { break }
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChattingProjectRequestCell.identifier, for: indexPath) as? ChattingProjectRequestCell else { break }
            return cell
        default: break
        }
        
        if indexPath.row % 2 == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChattingMessageCell.identifier, for: indexPath) as? ChattingMessageCell else { return UICollectionViewCell() }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyChattingMessageCell.identifier, for: indexPath) as? MyChattingMessageCell else { return UICollectionViewCell() }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0: return CGSize(width: collectionView.frame.width, height: 40)
        case 1: return CGSize(width: collectionView.frame.width, height: 240)
        default: break
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        24
    }
}
