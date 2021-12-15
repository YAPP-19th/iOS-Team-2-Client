//
//  LeftAlignedCollectionViewFlowLayout.swift
//  Budi
//
//  Created by 인병윤 on 2021/12/15.
//

import UIKit
// swiftlint:disable force_cast
class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)?.map { $0.copy() as! UICollectionViewLayoutAttributes }
        var leftMargin: CGFloat = 13.0
        var maxY: CGFloat = -1.0

        attributes?.forEach { layoutAttribute in
            guard layoutAttribute.representedElementCategory == .cell else {
                return
            }

            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = 13.0
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing - 5
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }

        return attributes
    }
}
