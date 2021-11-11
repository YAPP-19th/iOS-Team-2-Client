//
//  Extensions.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/10.
//

import Foundation
import UIKit

extension UIViewController {

    func addBackButton() {
        let backButton: UIButton = UIButton()
        let image = UIImage(named: "backButton")
        backButton.setImage(image, for: .normal)
        backButton.contentMode = .scaleAspectFit
        backButton.sizeThatFits(CGSize(width: 24, height: 24))
        backButton.addTarget(self, action: #selector(backButtonAction(sender:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = barButton
    }

    @objc
    func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
