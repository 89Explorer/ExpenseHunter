//
//  DetailChartCell.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/23/25.
//

import UIKit
import DGCharts

class DetailChartCell: UITableViewCell {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "DetailChartCell"
    
    
    // MARK: - UI Component
    private let pieChart = PieChartView()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    private func configureUI() {
        pieChart.legend.enabled = true
        pieChart.drawHoleEnabled = false
        pieChart.entryLabelColor = .label
        pieChart.setExtraOffsets(left: 8, top: 8, right: 8, bottom: 8)
        
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pieChart)
        NSLayoutConstraint.activate([
            pieChart.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            pieChart.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            pieChart.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            pieChart.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    
    func configureChart(
        with data: [(category: String, amount: Double)],
        usePercentage: Bool = false,
        animationEnabled: Bool = true
    ) {
        // 📌 데이터가 비었을 때 안내
        guard data.contains(where: { $0.amount > 0 }) else {
            pieChart.data = nil
            pieChart.centerText = nil  // ✅ centerText 제거
            pieChart.noDataText = NSLocalizedString("chart_no_data", comment: "No data available message")
            pieChart.notifyDataSetChanged()
            return
        }
        
        // 📝 데이터 매핑
        let entries = data.map { PieChartDataEntry(value: $0.amount, label: $0.category) }
        
        // 🌍 현지화된 라벨
        let categoryLabel = NSLocalizedString("chart_label_category", comment: "Label for category in pie chart")
        
        // 🥧 데이터셋 생성
        let dataSet = PieChartDataSet(entries: entries, label: categoryLabel)
        dataSet.sliceSpace = 2.0
        dataSet.selectionShift = 7
        
        // 🎨 유니크 색상 적용
        dataSet.colors = generateUniqueColors(count: entries.count)
        
        // 📏 라벨 표시 스타일
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.1
        dataSet.valueLinePart2Length = 0.2
        dataSet.yValuePosition = .outsideSlice
        dataSet.xValuePosition = .outsideSlice
        
        // 📦 차트 데이터 객체
        let pieData = PieChartData(dataSet: dataSet)
        pieData.setValueTextColor(.label)
        
        // 🔠 데이터 개수에 따라 폰트 크기 조정
        let dynamicFontSize: CGFloat = entries.count > 8 ? 8 : 12
        pieData.setValueFont(UIFont(name: "OTSBAggroL", size: dynamicFontSize) ?? .systemFont(ofSize: dynamicFontSize, weight: .medium))
        
        // 🔄 퍼센트 / 금액 표시
        if usePercentage {
            pieChart.usePercentValuesEnabled = true
            pieData.setValueFormatter(PercentageValueFormatter())
        } else {
            pieChart.usePercentValuesEnabled = false
            pieData.setValueFormatter(CurrencyValueFormatter())
        }
        
        // 📌 데이터 적용
        pieChart.data = pieData
        pieChart.notifyDataSetChanged()
        
        // 🎞 애니메이션 옵션
        if animationEnabled {
            pieChart.spin(duration: 1.0,
                          fromAngle: self.pieChart.rotationAngle,
                          toAngle: self.pieChart.rotationAngle + 120)
        }
    }
}


// MARK: - Extension: DetailChartCell
extension DetailChartCell {
    
    /// 🎨 유니크 색상 배열 생성
    func generateUniqueColors(count: Int) -> [UIColor] {
        
        var colors: [UIColor] = []
        
        for i in 0..<count {
            let hue = CGFloat(i) / CGFloat(count)
            colors.append(UIColor(hue: hue, saturation: 0.8, brightness: 0.9, alpha: 1.0))
        }
        return colors
    }
}
