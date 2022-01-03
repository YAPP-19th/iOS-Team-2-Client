//
//  GreetingAlertViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit

final class GreetingAlertViewController: UIViewController {

    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var button: UIButton!
    
    @IBAction private func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    @IBAction private func backgroundButtonTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    @IBAction private func chattingButtonTapped(_ sender: Any) {
    }
    
    let text: String
    
    init(nibName: String?, bundle: Bundle?, text: String) {
        self.text = text
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        textLabel.text = text
    }
}
