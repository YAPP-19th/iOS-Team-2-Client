//
//  UINavigationController+translucent.swift
//  Budi
//
//  Created by 최동규 on 2021/11/04.
//

import UIKit

extension UINavigationController {
    func setTranslucent() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        view.backgroundColor = .clear
        navigationBar.backgroundColor = .clear
    }

    func removeTranslucent() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        view.backgroundColor = .systemBackground
        navigationBar.backgroundColor = .systemBackground
    }
}
