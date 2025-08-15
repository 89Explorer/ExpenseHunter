//
//  MainSummaryCell.swift
//  ExpenseHunter
//
//  Created by 권정근 on 8/14/25.
//

import UIKit
import DGCharts
import Charts


class MainSummaryCell: UICollectionViewCell {
    
    // MARK: - Dummy Data
    private let incomeCategory: [String] = ["월급", "용돈", "상여금"]
    private let expenseCategory: [String] = ["월세", "교통비", "통신비"]
    
    private let incomeValue: [Double] = [2000000, 300000, 200000]
    private let expenseValue: [Double] = [500000, 400000, 30000]
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "MainSummaryCell"
    
    
    // MARK: - UI Component
    private let containerView: UIView = UIView()
    private let balanceAmount: UILabel = UILabel()
    private let balanceLabel: UILabel = UILabel()
    
    private let incomeContainer: UIView = UIView()
    private let incomeAmount: UILabel = UILabel()
    private let incomeLabel: UILabel = UILabel()
    private let incomeBarChart: BarChartView = BarChartView()
    
    private let expenseContainer: UIView = UIView()
    private let expenseAmount: UILabel = UILabel()
    private let expenseLabel: UILabel = UILabel()
    private let expenseBarChart: BarChartView = BarChartView()
    
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupDefaultChartSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    private func configureUI() {
        backgroundColor = .clear
        
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        containerView.backgroundColor = .systemBackground
        
        // Balance
        balanceAmount.font = UIFont(name: "Ownglyph_daelong-Rg", size: 32) ?? UIFont.systemFont(ofSize: 32, weight: .bold)
        balanceAmount.textColor = .label
        balanceAmount.textAlignment = .center
        balanceAmount.text = "₩ 1,250,000"
        
        balanceLabel.font = UIFont(name: "Ownglyph_daelong-Rg", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .regular)
        balanceLabel.textColor = .secondaryLabel
        balanceLabel.textAlignment = .center
        balanceLabel.text = "잔액"
        
        let balanceStackView = UIStackView(arrangedSubviews: [balanceAmount, balanceLabel])
        balanceStackView.axis = .vertical
        balanceStackView.spacing = 4
        balanceStackView.alignment = .fill
        balanceStackView.distribution = .fill
        
        
        // Income
        incomeAmount.font = UIFont(name: "Ownglyph_daelong-Rg", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .bold)
        incomeAmount.textColor = .systemGreen
        incomeAmount.textAlignment = .center
        incomeAmount.text = "₩1,250,000"
        
        incomeLabel.font = UIFont(name: "Ownglyph_daelong-Rg", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .regular)
        incomeLabel.textColor = .secondaryLabel
        incomeLabel.textAlignment = .center
        incomeLabel.text = "수입" + " (총 3건)"
        
        incomeBarChart.backgroundColor = .clear
        incomeBarChart.layer.cornerRadius = 4
        incomeBarChart.clipsToBounds = true
        
        let incomeStackView = UIStackView(arrangedSubviews: [incomeAmount, incomeLabel, incomeBarChart])
        incomeStackView.axis = .vertical
        incomeStackView.backgroundColor = .secondarySystemBackground
        incomeStackView.spacing = 4
        incomeStackView.layer.cornerRadius = 8
        incomeStackView.clipsToBounds = true
        //incomeStackView.alignment = .fill
        incomeStackView.distribution = .fill
        incomeStackView.isLayoutMarginsRelativeArrangement = true     // 내부 패딩
        incomeStackView.layoutMargins = UIEdgeInsets(top: 8, left: 4, bottom: 4, right: 4)
        
        
        // Expense
        expenseAmount.font = UIFont(name: "Ownglyph_daelong-Rg", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .bold)
        expenseAmount.textColor = .systemRed
        expenseAmount.textAlignment = .center
        expenseAmount.text = "₩1,250,000"
        
        expenseLabel.font = UIFont(name: "Ownglyph_daelong-Rg", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .regular)
        expenseLabel.textColor = .secondaryLabel
        expenseLabel.textAlignment = .center
        expenseLabel.text = "지출" + " (총 12건)"
        
        expenseBarChart.backgroundColor = .clear
        expenseBarChart.layer.cornerRadius = 4
        expenseBarChart.clipsToBounds = true
        
        let expenseStackView = UIStackView(arrangedSubviews: [expenseAmount, expenseLabel, expenseBarChart])
        expenseStackView.axis = .vertical
        expenseStackView.spacing = 4
        expenseStackView.backgroundColor = .secondarySystemBackground
        expenseStackView.layer.cornerRadius = 8
        expenseStackView.clipsToBounds = true
        //expenseStackView.alignment = .fill
        expenseStackView.distribution = .fill
        expenseStackView.isLayoutMarginsRelativeArrangement = true
        expenseStackView.layoutMargins = UIEdgeInsets(top: 8, left: 4, bottom: 4, right: 4)
        
        let summaryStackView = UIStackView(arrangedSubviews: [incomeStackView, expenseStackView])
        summaryStackView.axis = .horizontal
        summaryStackView.spacing = 12
        summaryStackView.distribution = .fillEqually
        
        let mainStackView = UIStackView(arrangedSubviews: [balanceStackView, summaryStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 4
        mainStackView.distribution = .fill
        //mainStackView.alignment = .fill
        
        
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        containerView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            mainStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            mainStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            
            incomeBarChart.heightAnchor.constraint(equalToConstant: 100),
            expenseBarChart.heightAnchor.constraint(equalToConstant: 100),
            
            //balanceStackView.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
//    private func configureChart() {
//        var incomeEntries: [BarChartDataEntry] = []
//        var expenseEntries: [BarChartDataEntry] = []
//        
//        // ✅ 1. for 루프 수정
//        for i in 0..<incomeCategory.count {
//            incomeEntries.append(BarChartDataEntry(x: Double(i), y: incomeValue[i]))
//        }
//        
//        for i in 0..<expenseCategory.count {
//            expenseEntries.append(BarChartDataEntry(x: Double(i), y: expenseValue[i]))
//        }
//        
//        let incomeDataSet = BarChartDataSet(entries: incomeEntries)
//        incomeDataSet.setColor(.systemGreen) // ✅ 적절한 색상 설정
//        incomeDataSet.drawValuesEnabled = true // 값 처리 (필요시)
//        incomeDataSet.valueFont = UIFont(name: "Ownglyph_daelong-Rg", size: 8) ?? UIFont.systemFont(ofSize: 10, weight: .regular)
//        
//        let expenseDataSet = BarChartDataSet(entries: expenseEntries)
//        expenseDataSet.setColor(.systemRed) // ✅ 적절한 색상 설정
//        expenseDataSet.drawValuesEnabled = true // 값 처리 (필요시)
//        expenseDataSet.valueFont = UIFont(name: "Ownglyph_daelong-Rg", size: 8) ?? UIFont.systemFont(ofSize: 10, weight: .regular)
//        
//        // ✅ 2. BarChartData 초기화 수정
//        let incomeData = BarChartData(dataSet: incomeDataSet)
//        let expenseData = BarChartData(dataSet: expenseDataSet)
//        
//        let barWidth = 0.8 // 막대 너비 조정 (1.0에서 0.8로 변경하면 그래프가 더 잘 보일 수 있습니다)
//        
//        incomeData.barWidth = barWidth
//        incomeBarChart.data = incomeData
//        
//        expenseData.barWidth = barWidth
//        expenseBarChart.data = expenseData
//        
//        // incomeBarChart 설정
//        incomeBarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: incomeCategory)
//        incomeBarChart.xAxis.granularity = 1
//        incomeBarChart.xAxis.labelPosition = .bottom
//        incomeBarChart.xAxis.centerAxisLabelsEnabled = false
//        incomeBarChart.xAxis.gridColor = .clear
//        incomeBarChart.xAxis.labelCount = incomeCategory.count
//        incomeBarChart.xAxis.labelFont = UIFont(name: "Ownglyph_daelong-Rg", size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .regular)
//        
//        // expenseBarChart 설정
//        expenseBarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: expenseCategory)
//        expenseBarChart.xAxis.granularity = 1
//        expenseBarChart.xAxis.labelPosition = .bottom
//        expenseBarChart.xAxis.centerAxisLabelsEnabled = false
//        expenseBarChart.xAxis.gridColor = .clear
//        expenseBarChart.xAxis.labelCount = expenseCategory.count
//        expenseBarChart.xAxis.labelFont = UIFont(name: "Ownglyph_daelong-Rg", size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .regular)
//        
//        // 공통 설정
//        incomeBarChart.rightAxis.enabled = false
//        incomeBarChart.leftAxis.enabled = false
//        incomeBarChart.leftAxis.axisMinimum = 0
//        incomeBarChart.legend.enabled = false
//        incomeBarChart.drawGridBackgroundEnabled = false // 그리드 배경 숨김
//        incomeBarChart.pinchZoomEnabled = false
//        incomeBarChart.doubleTapToZoomEnabled = false
//        incomeBarChart.highlightPerTapEnabled = false
//        incomeBarChart.scaleXEnabled = false
//        incomeBarChart.scaleYEnabled = false
//        incomeBarChart.isUserInteractionEnabled = false
//        
//        expenseBarChart.rightAxis.enabled = false
//        expenseBarChart.leftAxis.enabled = false
//        expenseBarChart.leftAxis.axisMinimum = 0
//        expenseBarChart.legend.enabled = false
//        expenseBarChart.drawGridBackgroundEnabled = false // 그리드 배경 숨김
//        expenseBarChart.pinchZoomEnabled = false
//        expenseBarChart.doubleTapToZoomEnabled = false
//        expenseBarChart.highlightPerTapEnabled = false
//        expenseBarChart.scaleXEnabled = false
//        expenseBarChart.scaleYEnabled = false
//        expenseBarChart.isUserInteractionEnabled = false
//    }
    
    private func setupDefaultChartSettings() {
        // 공통 설정
        let barWidth = 0.8
        let xAxisLabelFont = UIFont(name: "Ownglyph_daelong-Rg", size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .regular)
        let valueFont = UIFont(name: "Ownglyph_daelong-Rg", size: 8) ?? UIFont.systemFont(ofSize: 10, weight: .regular)

        let charts: [BarChartView] = [incomeBarChart, expenseBarChart]
        
        for chart in charts {
            // 공통 UI 설정
            chart.rightAxis.enabled = false
            chart.leftAxis.enabled = false
            chart.leftAxis.axisMinimum = 0
            chart.legend.enabled = false
            chart.drawGridBackgroundEnabled = false
            chart.barData?.barWidth = barWidth // 이 부분은 데이터가 먼저 설정된 후 할 수도 있습니다.

            // X축 설정
            chart.xAxis.granularity = 1
            chart.xAxis.labelPosition = .bottom
            chart.xAxis.centerAxisLabelsEnabled = false
            chart.xAxis.gridColor = .clear
            chart.xAxis.labelFont = xAxisLabelFont

            // 상호작용 비활성화
            chart.pinchZoomEnabled = false
            chart.doubleTapToZoomEnabled = false
            chart.highlightPerTapEnabled = false
            chart.scaleXEnabled = false
            chart.scaleYEnabled = false
            chart.isUserInteractionEnabled = false
        }
    }
    
    private func updateChartWith(incomeGraphData: [(category: String, amount: Double)], expenseGraphData: [(category: String, amount: Double)]) {
        // 사용자의 현재 로케일에 따라 통화단위 설정
        let valueFormatter = CurrencyValueFormatter(locale: Locale.current)
        
        // 수입 데이터 설정
        let incomeEntries = incomeGraphData.enumerated().map { (index, data) in
            BarChartDataEntry(x: Double(index), y: data.amount)
        }
        let incomeCategories = incomeGraphData.map { $0.category }
        
        let incomeDataSet = BarChartDataSet(entries: incomeEntries)
        incomeDataSet.setColor(.systemGreen)
        incomeDataSet.drawValuesEnabled = true
        incomeDataSet.valueFont = UIFont(name: "Ownglyph_daelong-Rg", size: 8) ?? UIFont.systemFont(ofSize: 10, weight: .regular)
        incomeDataSet.valueFormatter = valueFormatter

        let incomeData = BarChartData(dataSet: incomeDataSet)
        incomeData.barWidth = 0.8 // 막대 너비 설정
        incomeBarChart.data = incomeData
        incomeBarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: incomeCategories)
        incomeBarChart.xAxis.labelCount = incomeCategories.count
        
        // 지출 데이터 설정
        let expenseEntries = expenseGraphData.enumerated().map { (index, data) in
            BarChartDataEntry(x: Double(index), y: data.amount)
        }
        let expenseCategories = expenseGraphData.map { $0.category }

        let expenseDataSet = BarChartDataSet(entries: expenseEntries)
        expenseDataSet.setColor(.systemRed)
        expenseDataSet.drawValuesEnabled = true
        expenseDataSet.valueFont = UIFont(name: "Ownglyph_daelong-Rg", size: 8) ?? UIFont.systemFont(ofSize: 10, weight: .regular)
        expenseDataSet.valueFormatter = valueFormatter

        let expenseData = BarChartData(dataSet: expenseDataSet)
        expenseData.barWidth = 0.8 // 막대 너비 설정
        expenseBarChart.data = expenseData
        expenseBarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: expenseCategories)
        expenseBarChart.xAxis.labelCount = expenseCategories.count

        // 차트 업데이트 애니메이션
        incomeBarChart.animate(yAxisDuration: 0.5)
        expenseBarChart.animate(yAxisDuration: 0.5)
    }
    
    
    func configure(
        with balance: Int,
        income: Int,
        expense: Int,
        incomeCount: Int,
        expenseCount: Int,
        incomeGraphData: [(category: String, amount: Double)],
        expenseGraphData: [(category: String, amount: Double)]
    ) {
        // UI 업데이트
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if Locale.current.identifier == "ko" {
            formatter.locale = Locale(identifier: "ko_KR")
        } else {
            formatter.locale = Locale.current
        }
        
        let formattedIncomeAmount = formatter.string(from: NSNumber(value: income))
        incomeAmount.text = "\(formattedIncomeAmount ?? "0")"
        
        let formattedBalanceAmount = formatter.string(from: NSNumber(value: balance))
        balanceAmount.text = "\(formattedBalanceAmount ?? "0")"
        
        let formattedExpenseAmount = formatter.string(from: NSNumber(value: expense))
    
        expenseAmount.text = "\(formattedExpenseAmount ?? "0")"
        
        incomeLabel.text = "소득 총 \(incomeCount)건"
        expenseLabel.text = "지출 총 \(expenseCount)건"
        
        // 차트 기본 설정은 한 번만
        // setupDefaultChartSettings() // ✅ 만약 configure()가 여러 번 호출된다면, 이 메서드는 init()이나 awakeFromNib()에서 한 번만 호출하는 것이 좋습니다.
        
        // 데이터 업데이트
        updateChartWith(incomeGraphData: incomeGraphData, expenseGraphData: expenseGraphData)
    }
    
}

