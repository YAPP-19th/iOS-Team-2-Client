//
//  UIViewController+identifer.swift
//  Budi
//
//  Created by 최동규 on 2021/10/11.
//

import UIKit

extension UIViewController {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

extension UICollectionReusableView {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
