//
//  NSMutableAttributedString+font.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/18.
//

import UIKit

extension NSMutableAttributedString {

    func font(_ text: String, ofSize: CGFloat, weight: UIFont.Weight) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: ofSize, weight: weight)]
        self.append(NSMutableAttributedString(string: text, attributes: attributes))
        return self
    }
}
