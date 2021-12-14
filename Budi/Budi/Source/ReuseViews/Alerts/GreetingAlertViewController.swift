//
//  GreetingAlertViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit

final class GreetingAlertViewController: UIViewController {

    @IBOutlet private weak var handEmojiLabel: UILabel!
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        handEmojiLabel.transform = CGAffineTransform(rotationAngle: -(CGFloat.pi / 180 * 12))
    }
}
