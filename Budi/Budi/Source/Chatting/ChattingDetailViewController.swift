//
//  ChattingDetailViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit
import Moya
import Combine
import CombineCocoa
import Firebase

final class ChattingDetailViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var textFieldContainerView: UIView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var sendButton: UIButton!

    private var textFieldText: String = ""
    private var keyboardHeight: CGFloat?
    private var isKeyboardShown: Bool = false
    
    weak var coordinator: ChattingCoordinator?
    private let viewModel: ChattingViewModel
    private var cancellables = Set<AnyCancellable>()
    
    let userId: String = "userId"
    let toId: String = "toId"
    
    init(viewModel: ChattingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    init?(coder: NSCoder, viewModel: ChattingViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("This viewController must be init with viewModel")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTabBar()
        configureTextField()
        configureKeyboardHeight()
        
        bindViewModel()
        setPublisher()
        configureCollectionView()
        
        firebaseTestLogin()
    }

    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
}

private extension ChattingDetailViewController {
    func firebaseTestLogin() {
  
    }
    
    func bindViewModel() {
        viewModel.state.chatMessages
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.collectionView.reloadData()
            }).store(in: &cancellables)
    }
    
    func setPublisher() {
        sendButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.sendMessage()
            }.store(in: &cancellables)
        
        collectionView.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.hideTextField()
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
        guard !textFieldText.isEmpty else { return }
//        let newMessage = ChatMessage()
//        viewModel.state.chatMessages.value.append(newMessage)
        self.textFieldText = ""
        self.textField.text = ""
    }
    
    private func configureTextField() {
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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
            textFieldText = text
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
        collectionView.dataSource = self
        collectionView.delegate = self
        let cellClasses = [ChattingMessageCell.self, MyChattingMessageCell.self]
        cellClasses.forEach {
            collectionView.register(.init(nibName: $0.identifier, bundle: nil), forCellWithReuseIdentifier: $0.identifier)
        }
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .border
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.state.chatMessages.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = viewModel.state.chatMessages.value[indexPath.row]
     
        let isFromCurrentUser = (message.fromUserId == userId)
        
        if isFromCurrentUser {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyChattingMessageCell.identifier, for: indexPath) as? MyChattingMessageCell else { return UICollectionViewCell() }
            cell.configureUI(message)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChattingMessageCell.identifier, for: indexPath) as? ChattingMessageCell else { return UICollectionViewCell() }
            cell.configureUI(message)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12
    }
}
