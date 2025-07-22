//
//  HomeChartCell.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/15/25.
//

import UIKit
import Charts
import DGCharts

class HomeChartCell: UITableViewCell {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "HomeChartCell"
    
    // 더미 데이터
    private let days: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun" ]
    private let incomeValues: [Double] = [50000, 30000, 20000, 60000, 10000, 40000, 30000]
    private let expenseValues: [Double] = [2000000, 150000, 300000, 200000, 250000, 1000000, 1200000]
    
    
    // MARK: - UI Component
    private let containerView: UIView = UIView()
    private let weekBarChart = BarChartView()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureChartData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    private func configureUI() {
        contentView.backgroundColor = .clear
        
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 8
        //        containerView.layer.shadowColor = UIColor.label.cgColor
        //        containerView.layer.shadowOpacity = 0.5
        //        containerView.layer.shadowOffset = CGSize(width: 0, height: 8)
        //        containerView.layer.shadowRadius = 8
        //        containerView.layer.masksToBounds = false
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        weekBarChart.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(containerView)
        containerView.addSubview(weekBarChart)
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            weekBarChart.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            weekBarChart.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            weekBarChart.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            weekBarChart.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
        ])
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return "₩" + (formatter.string(from: NSNumber(value: value)) ?? "0")
    }
    
    // DataSet 구성 메서드
    private func configureChartData() {
        var incomeEntries: [BarChartDataEntry] = []
        var expenseEntries: [BarChartDataEntry] = []
        
        // 요일별 수입 / 지출 데이터 생성
        for i in 0..<days.count {
            incomeEntries.append(BarChartDataEntry(x: Double(i), y: incomeValues[i]))
            expenseEntries.append(BarChartDataEntry(x: Double(i), y: expenseValues[i]))
        }
        
        // 수입 / 지출 데이터셋 생성
        let incomeDataSet = BarChartDataSet(entries: incomeEntries, label: "수입")
        incomeDataSet.setColor(.systemGreen)
        
        let expenseDataSet = BarChartDataSet(entries: expenseEntries, label: "지출")
        expenseDataSet.setColor(.systemRed)
        
        // 차트에 데이터셋 적용 (Grouped BarChart 설정)
        let data = BarChartData(dataSets: [incomeDataSet, expenseDataSet])
        let groupSpace = 0.2       // 수입 / 지출 그룹 간 간격
        let barSpace = 0.05        // 수입과 지출 막대 사이 간격
        let barWidth = 0.35        // 각 막대의 너비
        
        data.barWidth = barWidth   // 데이터의 bar 너비 설정
        weekBarChart.data = data   // 차트에 데이터 주입
        
        // X축 설정: 요일 기준으로 라벨 표시
        weekBarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        weekBarChart.xAxis.granularity = 1
        weekBarChart.xAxis.labelPosition = .bottom               // x축 라벨을 하단에 배치
        weekBarChart.xAxis.centerAxisLabelsEnabled = true
        
        // Y축 및 기타 설정
        weekBarChart.rightAxis.enabled = false
        weekBarChart.leftAxis.axisMinimum = 0      // Y축 값의 최소값 설정 (0부터 시작)
        weekBarChart.legend.enabled = true         // 범례 활성화 (수입 / 지출 구분용 라벨)
        weekBarChart.animate(yAxisDuration: 1.0)
        
        weekBarChart.pinchZoomEnabled = false      // 핀치 줌 비활성화
        weekBarChart.doubleTapToZoomEnabled = false // 더블탭 확대 비활성화
        weekBarChart.scaleXEnabled = false         // X축 방향 스케일(줌) 비활성화
        weekBarChart.scaleYEnabled = false         // Y축 방향 스케일(줌) 비활성화
        
        // 드래그, 스크롤 비활성화
        weekBarChart.dragEnabled = false
        weekBarChart.highlightPerTapEnabled = false
        weekBarChart.highlightPerDragEnabled = false
        weekBarChart.legend.enabled = true
        
        
        // 그룹 바의 X축 범위 및 그룹 설정
        weekBarChart.xAxis.axisMinimum = 0
        let groupWidth = data.groupWidth(groupSpace: groupSpace, barSpace: barSpace)     // 전체 그룹 하나의 폭 계산
        weekBarChart.xAxis.axisMaximum = 0 + groupWidth * Double(days.count)
        weekBarChart.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
    }
    
    
    func configureChart(with weeklyData: [(day: String, income: Double, expense: Double)]) {
        let days = weeklyData.map { $0.day }
        let incomeValues = weeklyData.map { $0.income }
        let expenseValues = weeklyData.map { $0.expense }
        
        var incomeEntries: [BarChartDataEntry] = []
        var expenseEntries: [BarChartDataEntry] = []
        
        for i in 0..<days.count {
            incomeEntries.append(BarChartDataEntry(x: Double(i), y: incomeValues[i]))
            expenseEntries.append(BarChartDataEntry(x: Double(i), y: expenseValues[i]))
        }
        
        let incomeDataSet = BarChartDataSet(entries: incomeEntries, label: "수입")
        incomeDataSet.setColor(.systemGreen)
        
        let expenseDataSet = BarChartDataSet(entries: expenseEntries, label: "수출")
        expenseDataSet.setColor(.systemRed)
        
        let data = BarChartData(dataSets: [incomeDataSet, expenseDataSet])
        data.barWidth = 0.35
        let groupSpace: CGFloat = 0.2
        let barSpace: CGFloat = 0.05
        
        weekBarChart.data = data
        weekBarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        weekBarChart.xAxis.axisMinimum = 0
        let groupWidth = data.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        weekBarChart.xAxis.axisMaximum = 0 + groupWidth * Double(days.count)
        weekBarChart.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
        
        weekBarChart.notifyDataSetChanged()
        
    }
}


