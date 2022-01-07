//
//  ErrorAlertViewController.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/06.
//

import UIKit
import Combine

final class ErrorAlertViewController: UIViewController {
    
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
        
    private let message: ErrorMessage
    
    private var cancellables = Set<AnyCancellable>()
    
    init(_ message: ErrorMessage = ErrorMessage.defaultMessage) {
        self.message = message
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPublisher()
        configureUI()
    }
    
    private func setPublisher() {
        view.gesturePublisher(.tap())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.dismiss(animated: false, completion: nil)
            }.store(in: &cancellables)
        
        cancelButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.dismiss(animated: false, completion: nil)
            }.store(in: &cancellables)
    }
    
    private func configureUI() {
        messageLabel.text = message.stringValue
        if message != ErrorMessage.defaultMessage {
            imageView.image = UIImage(named: "bg_error")
        }
        
    }
}
