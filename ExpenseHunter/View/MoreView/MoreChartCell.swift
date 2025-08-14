//
//  MoreChartCell.swift
//  ExpenseHunter
//
//  Created by 권정근 on 8/13/25.
//

import UIKit
import DGCharts
import Charts


class MoreChartCell: UICollectionViewCell {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "MoreChartCell"
    
    
    // MARK: - UI Component
    private let containerView: UIView = UIView()
    private let monthBarChart: HorizontalBarChartView = HorizontalBarChartView()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    private func configureUI() {
        contentView.backgroundColor = .clear
        
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 8
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        monthBarChart.translatesAutoresizingMaskIntoConstraints = false
        monthBarChart.rightAxis.enabled = false
        monthBarChart.leftAxis.axisMinimum = 0
        monthBarChart.xAxis.labelPosition = .bottom
        monthBarChart.xAxis.granularity = 1
        monthBarChart.legend.enabled = false
        
        contentView.addSubview(containerView)
        containerView.addSubview(monthBarChart)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            monthBarChart.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            monthBarChart.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            monthBarChart.topAnchor.constraint(equalTo: containerView.topAnchor),
            monthBarChart.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return "₩" + (formatter.string(from: NSNumber(value: value)) ?? "0")
    }
    
    // 데이터를 받아 가로형 막대그래프를 설정하는 메서드
    func configure(with weeklyTotals: [(week: Int, total: Double)]) {
        // 1. 차트 엔트리 생성
        let entries = weeklyTotals.enumerated().map { index, element in
            BarChartDataEntry(x: Double(index), y: element.total)
        }

        // 2. 차트 데이터셋 설정
        let set = BarChartDataSet(entries: entries, label: "주차별 수입 총합")
        set.colors = [UIColor.systemBlue]
        set.valueFormatter = DefaultValueFormatter(formatter: {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 0
            return formatter
        }())

        // 3. 차트 데이터 설정
        let chartData = BarChartData(dataSet: set)
        
        // 4. 가로형 막대그래프(HorizontalBarChartView)에 데이터 적용
        if let horizontalBarChart = monthBarChart as? HorizontalBarChartView {
            horizontalBarChart.data = chartData
        
            // 5. Y축 라벨(주차) 설정
            horizontalBarChart.leftAxis.valueFormatter = IndexAxisValueFormatter(values: weeklyTotals.map { "\($0.week)주차" })
            horizontalBarChart.leftAxis.labelPosition = .insideChart
            horizontalBarChart.leftAxis.drawGridLinesEnabled = false
            horizontalBarChart.leftAxis.drawAxisLineEnabled = false
            horizontalBarChart.leftAxis.axisMinimum = -0.5
            horizontalBarChart.rightAxis.enabled = false
            
            // 6. X축 설정
            // **수정**: X축을 비활성화하여 숨깁니다.
            horizontalBarChart.xAxis.enabled = true
            
            // 7. 기타 차트 시각적 설정
            horizontalBarChart.legend.enabled = true
            horizontalBarChart.drawValueAboveBarEnabled = true
            horizontalBarChart.animate(yAxisDuration: 1.5)
            horizontalBarChart.setExtraOffsets(left: 20.0, top: 20, right: 20.0, bottom: 20)
        }
    }
}
