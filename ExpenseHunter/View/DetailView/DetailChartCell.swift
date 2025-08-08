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
        
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pieChart)
        NSLayoutConstraint.activate([
            pieChart.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            pieChart.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            pieChart.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            pieChart.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
//    func configureChart(with data: [(category: String, amount: Double)]) {
//        let entries = data.map { PieChartDataEntry(value: $0.amount, label: $0.category) }
//        let dataSet = PieChartDataSet(entries: entries, label: "지출 항목")
//        
//        dataSet.sliceSpace = 2.0
//        dataSet.selectionShift = 7
//        
//        // ✅ 색상 지정 (예시)
//        dataSet.colors = ChartColorTemplates.material() +
//        ChartColorTemplates.joyful() +
//        ChartColorTemplates.pastel()
//        
//        let pieData = PieChartData(dataSet: dataSet)
//        pieData.setValueTextColor(.label)
//        //pieData.setValueFont(.systemFont(ofSize: 12, weight: .medium))
//        pieData.setValueFont(UIFont(name: "OTSBAggroL", size: 10) ?? (.systemFont(ofSize: 12, weight: .medium)))
//        
//        // ✅ 커스텀 포맷터 적용
//        pieData.setValueFormatter(CurrencyValueFormatter())
//        
//        pieChart.data = pieData
//        pieChart.notifyDataSetChanged()
//    }
    
    func configureChart(with data: [(category: String, amount: Double)], usePercentage: Bool = false) {
        let entries = data.map { PieChartDataEntry(value: $0.amount, label: $0.category) }
        
        
        let category = NSLocalizedString("category", comment: "Label for category")
        let dataSet = PieChartDataSet(entries: entries, label: category)

        dataSet.sliceSpace = 2.0
        dataSet.selectionShift = 7

        dataSet.colors = ChartColorTemplates.material() +
                         ChartColorTemplates.joyful() +
                         ChartColorTemplates.pastel()

        // ✅ 퍼센트 표시 여부 설정
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.4
        dataSet.yValuePosition = .outsideSlice  // 라벨을 차트 밖으로 그리면서 선(line)을 함께 그리는 옵션이 활성화
        dataSet.xValuePosition = .outsideSlice

        let pieData = PieChartData(dataSet: dataSet)
        pieData.setValueTextColor(.label)
        pieData.setValueFont(UIFont(name: "OTSBAggroL", size: 10) ?? .systemFont(ofSize: 12, weight: .medium))

        // ✅ 조건에 따라 포맷터 설정
        if usePercentage {
            // 퍼센트 사용 시, PieChartView에도 설정
            pieChart.usePercentValuesEnabled = true
            pieData.setValueFormatter(PercentageValueFormatter())
        } else {
            pieChart.usePercentValuesEnabled = false
            pieData.setValueFormatter(CurrencyValueFormatter())
        }

        pieChart.data = pieData
        pieChart.notifyDataSetChanged()
    }
}
