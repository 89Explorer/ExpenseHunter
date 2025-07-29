//
//  DetailChartViewController.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/22/25.
//

import UIKit
import Combine


class DetailChartViewController: UIViewController {
    
    
    // MARK: - Variable
    private var transactionType: TransactionType
    private var transactionViewModel = TransactionViewModel()
    private var cancellables: Set<AnyCancellable> = []
    private var filteredData: [(category: String, amount: Double)] = []
    
    
    let dummyData = [
        (category: "식비", amount: 150000.0),
        (category: "교통", amount: 60000.0),
        (category: "문화생활", amount: 40000.0),
        (category: "쇼핑", amount: 100000.0)
    ]
    
    
    // MARK: - UI Component
    private let chartTableView: UITableView = UITableView(frame: .zero, style: .grouped)
    
    
    
    // MARK: - init
    init(type: TransactionType) {
        self.transactionType = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        print("선택된 type: \(transactionType)")
        configureUI()
        configureNavigaiton()
        transactionViewModel.readAllTransactions()
        bindViewModel()
    }
    
    
    
    // MARK: - Function
    private func bindViewModel() {
        transactionViewModel.$transactions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] allData in
                guard let self else { return }

                let currentDate = Date()
                let calendar = Calendar.current
                let currentYear = calendar.component(.year, from: currentDate)
                let currentMonth = calendar.component(.month, from: currentDate)

                self.filteredData = self.processData(allData, forYear: currentYear, month: currentMonth)
                self.chartTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    
    private func processData(_ data: [ExpenseModel], forYear year: Int, month: Int) -> [(category: String, amount: Double)] {
        let calendar = Calendar.current

        let filtered = data.filter {
            $0.transaction == transactionType &&
            calendar.component(.year, from: $0.date) == year &&
            calendar.component(.month, from: $0.date) == month
        }

        let grouped = Dictionary(grouping: filtered, by: { $0.category })
            .map { (category, models) -> (String, Double) in
                let total = models.reduce(0) { $0 + Double($1.amount) }
                return (category, total)
            }

        return grouped
    }
    
    
    private func configureUI() {
        chartTableView.showsVerticalScrollIndicator = false
        chartTableView.backgroundColor = .clear
        
        chartTableView.rowHeight = UITableView.automaticDimension
        chartTableView.estimatedRowHeight = 150
        
        chartTableView.delegate = self
        chartTableView.dataSource = self
        
        chartTableView.register(DetailChartCell.self, forCellReuseIdentifier: DetailChartCell.reuseIdentifier)
        chartTableView.register(HomeTodayStatusCell.self, forCellReuseIdentifier: HomeTodayStatusCell.reuseIdentifier)
        
        view.addSubview(chartTableView)
        chartTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chartTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chartTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            chartTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            chartTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}


// MARK: - Extension
extension DetailChartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ChartTable.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = ChartTable(rawValue: section) else { fatalError("numberOfRowsInSection Error") }
        switch section {
        case .chart:
            return 1
        case .detail:
            return filteredData.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = ChartTable(rawValue: section) else { return nil }
        
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let label = UILabel()
        label.text = section.title
        label.font = UIFont(name: "OTSBAggroB", size: 20)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = ChartTable(rawValue: indexPath.section) else { fatalError("Invalid section")  }
        
        switch section {
        case .chart:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailChartCell.reuseIdentifier, for: indexPath) as? DetailChartCell else { return UITableViewCell() }
            cell.configureChart(with: filteredData, usePercentage: true)
            return cell
        case .detail:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTodayStatusCell.reuseIdentifier, for: indexPath) as? HomeTodayStatusCell else { return UITableViewCell() }
            let sortedData = filteredData.sorted { $0.amount > $1.amount }
            let item = sortedData[indexPath.row]
            cell.configureChart(with: item, type: transactionType)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = ChartTable(rawValue: indexPath.section) else { fatalError("Invalid section") }
        switch section {
        case .chart:
            return 350
        case .detail:
            return 68
        }
    }
}



// MARK: - Extension: 네비게이션
extension DetailChartViewController {
    
    // 네비게이션 타이틀 설정
    private func configureNavigaiton() {
        let titleLabel: UILabel = UILabel()
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        
        switch transactionType {
        case .income:
            titleLabel.text = "📥 이번달, 누적 수입"
        case .expense:
            titleLabel.text = "📤 이번달, 누적 지출"
        }
        
        titleLabel.font = UIFont(name: "OTSBAggroB", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.sizeToFit()
        
        self.navigationItem.titleView = titleLabel
    }
}


// MARK: - Enum: chartTableView 의 섹션 구분하기 위한 열거형
enum ChartTable: Int, CaseIterable {
    case chart
    case detail
    
    var title: String {
        switch self {
        case .chart:
            return "📊 차트"
        case .detail:
            return "📋 상세"
        }
    }
}

