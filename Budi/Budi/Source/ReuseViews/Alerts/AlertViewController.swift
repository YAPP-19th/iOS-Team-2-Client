//
//  AlertViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/04.
//

import UIKit

final class AlertViewController: UIViewController {

    private var titleText: String = ""
    private var okButtonText: String = ""
    private var noButtonText: String = ""

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var noButton: UIButton!

    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func okButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func noButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = titleText
        okButton.setTitle(okButtonText, for: .normal)
        noButton.setTitle(noButtonText, for: .normal)
    }

    init(_ titleText: String, _ okButtonText: String, _ noButtonText: String) {
        super.init(nibName: nil, bundle: nil)

        self.titleText = titleText
        self.okButtonText = okButtonText
        self.noButtonText = noButtonText
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
