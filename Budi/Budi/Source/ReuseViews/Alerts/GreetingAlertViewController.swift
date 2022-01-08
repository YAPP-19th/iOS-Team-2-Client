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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
