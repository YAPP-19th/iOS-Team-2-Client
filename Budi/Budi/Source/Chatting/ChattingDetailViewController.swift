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
    private let manager = ChatManager.shared
    
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
        configureKeyboard()
        
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
        viewModel.state.messages
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.collectionView.reloadData()
                self.scrollToBottom()
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
                self?.hideKeyboard()
            }.store(in: &cancellables)
        
        textFieldContainerView.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                if !self.isKeyboardShown {
                    self.showKeyboard()
                    self.scrollToBottom()
                }
            }.store(in: &cancellables)
    }
    
    func configureNavigationBar() {
        let ellipsisButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(ellipsisBarButtonTapped))
        ellipsisButton.tintColor = .black
        navigationItem.rightBarButtonItem = ellipsisButton
        
        if let username = viewModel.state.oppositeUser.value?.username {
            title = username
        }
    }
    
    @objc
    func ellipsisBarButtonTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(.init(title: "대화 삭제", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            let oppositeUsername = self.viewModel.state.oppositeUser.value?.username ?? "상대 유저"
            let alertVC = AlertViewController("\(oppositeUsername)와의 대화를 삭제하시겠습니까? 삭제한 대화는 복구가 불가능합니다.", "삭제", "취소")
            alertVC.modalPresentationStyle = .overCurrentContext
            alertVC.delegate = self
            self.present(alertVC, animated: false, completion: nil)
        }))
        alert.addAction(.init(title: "취소", style: .cancel, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }

    func configureTabBar() {
        tabBarController?.tabBar.isHidden = true
    }
}

// MARK: - Delegate
extension ChattingDetailViewController: AlertViewControllerDelegate {
    func okButtonTapped() {
        guard let currentUid = viewModel.state.currentUser.value?.id, let oppositeUid = viewModel.state.oppositeUser.value?.id else { return }
        manager.removeAllMessages(currentUid, oppositeUid)
        navigationController?.popViewController(animated: false)
    }
}

// MARK: - TextField
extension ChattingDetailViewController: UITextFieldDelegate {
    private func sendMessage() {
        guard !textFieldText.isEmpty else { return }
        guard let currentUser = viewModel.state.currentUser.value, let oppositeUser = viewModel.state.oppositeUser.value else { return }
        
        ChatManager.shared.sendMessage(from: currentUser, to: oppositeUser, text: textFieldText)
        
        self.textFieldText = ""
        self.textField.text = ""
        
        scrollToBottom()
    }
    
    private func scrollToBottom(_ animated: Bool = false) {
        guard collectionView.numberOfSections > 0 else { return }
        let indexPath = IndexPath(item: collectionView.numberOfItems(inSection: collectionView.numberOfSections - 1) - 1, section: collectionView.numberOfSections - 1)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: animated)
    }
    
    private func configureTextField() {
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func showKeyboard() {
        self.isKeyboardShown = true
        self.textField.becomeFirstResponder()
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear) { [weak self] in
            guard let self = self else { return }
            self.bottomViewBottomConstraint.constant = (self.keyboardHeight ?? 0) - 23
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    private func hideKeyboard() {
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
        sendMessage()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showKeyboard()
    }
    
    func configureKeyboard() {
        textField.returnKeyType = .send
        
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

// MARK: - Delegate
extension ChattingDetailViewController: ChattingProjectRequestCellDelegate, MyChattingProjectRequestCellDelegate {
    func acceptApply() {
        viewModel.acceptApply { result in
            switch result {
            case .success(let response):
                do {
                    guard let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any] else { return }
                    print("json == \(json)")
                } catch {}
            case .failure(let error): print(error.localizedDescription)
            }
        }
    }
}

// MARK: - CollectionView
extension ChattingDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        let cellClasses = [ChattingMessageCell.self, MyChattingMessageCell.self, ChattingMessageEmojiCell.self, MyChattingMessageEmojiCell.self, ChattingProjectRequestCell.self, MyChattingProjectRequestCell.self]
        cellClasses.forEach {
            collectionView.register(.init(nibName: $0.identifier, bundle: nil), forCellWithReuseIdentifier: $0.identifier)
        }
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .background
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.state.messages.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let currentUser = viewModel.state.currentUser.value else { return UICollectionViewCell() }
        
        let message = viewModel.state.messages.value[indexPath.row]
        let isForApply = message.isForApply
        let isFromCurrentUser = (message.senderId == currentUser.id)
        let isSingleEmojiMessage = message.text.isSingleEmoji
        
        if isForApply {
            if isFromCurrentUser {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyChattingProjectRequestCell.identifier, for: indexPath) as? MyChattingProjectRequestCell else { return UICollectionViewCell() }
                cell.delegate = self
                cell.configureUI(message)
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChattingProjectRequestCell.identifier, for: indexPath) as? ChattingProjectRequestCell else { return UICollectionViewCell() }
                cell.delegate = self
                cell.configureUI(message)
                return cell
            }
        }
        
        if isFromCurrentUser {
            if !isSingleEmojiMessage {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyChattingMessageCell.identifier, for: indexPath) as? MyChattingMessageCell else { return UICollectionViewCell() }
                cell.configureUI(message)
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyChattingMessageEmojiCell.identifier, for: indexPath) as? MyChattingMessageEmojiCell else { return UICollectionViewCell() }
                cell.configureUI(message)
                return cell
            }
        } else {
            if !isSingleEmojiMessage {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChattingMessageCell.identifier, for: indexPath) as? ChattingMessageCell else { return UICollectionViewCell() }
                cell.configureUI(message)
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChattingMessageEmojiCell.identifier, for: indexPath) as? ChattingMessageEmojiCell else { return UICollectionViewCell() }
                cell.configureUI(message)
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: collectionView.frame.width, height: 150)
        let message = viewModel.state.messages.value[indexPath.row]
        
        if message.isForApply { size.height = 150 }
        
        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
