//
//  AlertViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit

class AlertViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var noButton: UIButton!

    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func okButtonTapped(_ sender: Any) {
    }

    @IBAction func noButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    init(_ label: String, _ okButtonLabel: String, _ noButtonLabel: String) {
        super.init(nibName: nil, bundle: nil)

        textLabel?.text = label
        okButton?.setTitle(okButtonLabel, for: .normal)
        noButton?.setTitle(noButtonLabel, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
