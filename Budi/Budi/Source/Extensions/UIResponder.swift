//
//  UIResponder.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/13.
//

import UIKit

extension UIResponder {
    private static weak var firstResponder: UIResponder?

    static var currentFirstResponder: UIResponder? {
        firstResponder = nil

        UIApplication.shared.sendAction(
            #selector(UIResponder.findFirstResponder(_:)),
            to: nil,
            from: nil,
            for: nil)

        return firstResponder
    }

    @objc
    func findFirstResponder(_ sender: Any) {
        UIResponder.firstResponder = self
    }
}
