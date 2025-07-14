//
//  ChartViewCell.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/15/25.
//

import UIKit
import DGCharts


class ChartViewCell: UICollectionViewCell, ChartViewDelegate {
    
    // MARK: - Variable
    static let reuseIdentifier: String = "ChartViewCell"
    
    // MARK: - UI Component
    private let expensePieChart = PieChartView()
    private let incomePieChart = PieChartView()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        
        expensePieChart.delegate = self
        incomePieChart.delegate = self
        
        setupUI()
        configureDummyData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        expensePieChart.translatesAutoresizingMaskIntoConstraints = false
        incomePieChart.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(expensePieChart)
        contentView.addSubview(incomePieChart)
        
        NSLayoutConstraint.activate([
            expensePieChart.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            expensePieChart.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            expensePieChart.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            expensePieChart.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.45),

            incomePieChart.topAnchor.constraint(equalTo: expensePieChart.bottomAnchor, constant: 12),
            incomePieChart.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            incomePieChart.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            incomePieChart.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    // MARK: - Dummy Data
    private func configureDummyData() {
        // Expense dummy
        let expenseEntries = [
            PieChartDataEntry(value: 40000, label: "식비"),
            PieChartDataEntry(value: 20000, label: "교통비"),
            PieChartDataEntry(value: 10000, label: "문화생활")
        ]
        
        let expenseSet = PieChartDataSet(entries: expenseEntries, label: "지출")
        expenseSet.colors = ChartColorTemplates.pastel()
        expenseSet.entryLabelColor = .label
        expenseSet.valueTextColor = .label
        expenseSet.valueFont = .systemFont(ofSize: 12, weight: .semibold)
        expensePieChart.data = PieChartData(dataSet: expenseSet)

        let attrText = NSAttributedString(
            string: "지출 구성",
            attributes: [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 14, weight: .bold)
            ]
        )
        expensePieChart.centerAttributedText = attrText
        
        //expensePieChart.centerText = "지출 구성"
        expensePieChart.animate(xAxisDuration: 1.0, easingOption: .easeOutBack)

        // Income dummy
        let incomeEntries = [
            PieChartDataEntry(value: 200000, label: "월급"),
            PieChartDataEntry(value: 50000, label: "성과금")
        ]
        
        
        let incomeSet = PieChartDataSet(entries: incomeEntries, label: "수입")
        incomeSet.colors = ChartColorTemplates.pastel()
        incomeSet.entryLabelColor = .label
        incomeSet.valueTextColor = .label
        incomeSet.valueFont = .systemFont(ofSize: 12, weight: .semibold)
        incomePieChart.data = PieChartData(dataSet: incomeSet)
        
        let incomeAttrText = NSAttributedString(
            string: "수입 구성",
            attributes: [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 14, weight: .bold)
            ]
        )
        incomePieChart.centerAttributedText = incomeAttrText
    
        //incomePieChart.centerText = "수입 구성"
        incomePieChart.animate(xAxisDuration: 1.0, easingOption: .easeOutBack)
    }
}
