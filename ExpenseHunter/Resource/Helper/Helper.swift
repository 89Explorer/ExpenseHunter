//
//  Helper.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/15/25.
//

import Foundation
import UIKit
import DGCharts


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

/*
 PieChartData에서 기본적으로 Double 값을 String으로 변환해 표시
 이걸 원하는 형식(예: ₩ 25,000,000 원)으로 표시하려면 PieChartData의 값 포맷터(ValueFormatter)를 커스텀
 */
class CurrencyValueFormatter: NSObject, ValueFormatter {

    private let formatter: NumberFormatter

    override init() {
        self.formatter = NumberFormatter()
        self.formatter.numberStyle = .decimal
        self.formatter.groupingSeparator = ","
        self.formatter.maximumFractionDigits = 0
        super.init()
    }

    // ✅ DGCharts에서는 이 메서드를 구현해야 함
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        return "₩ \(formatter.string(from: NSNumber(value: value)) ?? "0") 원"
    }
}

// 퍼센트 포맷터를 구현한 클래스
class PercentageValueFormatter: NSObject, ValueFormatter {
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        return String(format: "%.1f%%", value)
    }
}
