//
//  Helper.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/15/25.
//

import Foundation
import UIKit


class BasePaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}

// 폰트 확인
func checkFont() {
    for family in UIFont.familyNames {
        print("Font Family: \(family)")
        for name in UIFont.fontNames(forFamilyName: family) {
            print("    Font Name: \(name)")
        }
    }
}
