//
//  DetailCalendarViewController.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/24/25.
//

import UIKit
import Combine

class DetailCalendarViewController: UIViewController {
    
    
    // MARK: - Variable
    private let transactionViewModel = TransactionViewModel()
    private var cancellables: Set<AnyCancellable> = []
    private var selectedDate: Date = Date()
    private var filteredTransactions: [ExpenseModel] = []
    
    
    
    // MARK: - UI Component
    private let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        transactionViewModel.readAllTransactions()
        bindViewModel()
        configureNavigaiton()
    }
    
    
    // MARK: - Function
    private func bindViewModel() {
        transactionViewModel.$transactions
            .sink { [weak self] transactions in
                guard let self else { return }
                self.applyFilter()
            }
            .store(in: &cancellables)
    }
    
    private func applyFilter() {
        let calendar = Calendar.current
        let targetDate = calendar.startOfDay(for: selectedDate)

        filteredTransactions = transactionViewModel.transactions.filter {
            let date = calendar.startOfDay(for: $0.date)
            let match = calendar.isDate(date, inSameDayAs: targetDate)
            print("🟡 \(date) vs \(targetDate) => \(match)")
            return match
        }
        print("🟢 필터링된 거래 수: \(filteredTransactions.count)")
        tableView.reloadData()
    }
    
    private func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(DetailCalendarCell.self, forCellReuseIdentifier: DetailCalendarCell.reuseIdentifier)
        tableView.register(HomeTodayStatusCell.self, forCellReuseIdentifier: HomeTodayStatusCell.reuseIdentifier)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


// MARK: - Extension: 테이블 설정
extension DetailCalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DetailCalendar.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = DetailCalendar(rawValue: section) else { fatalError("Invalid Error") }
        switch section {
        case .calendar:
            return 1
        case .detailTable:
            return filteredTransactions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = DetailCalendar(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .calendar:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailCalendarCell.reuseIdentifier, for: indexPath) as? DetailCalendarCell else { return UITableViewCell() }
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case .detailTable:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTodayStatusCell.reuseIdentifier, for: indexPath) as? HomeTodayStatusCell else { return UITableViewCell() }
            let item = filteredTransactions[indexPath.row]
            cell.configure(with: item)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = DetailCalendar(rawValue: section) else { return nil }
        
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let label = UILabel()
        label.text = section.tile
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = DetailCalendar(rawValue: indexPath.section) else { fatalError("Invalid section") }
        switch section {
        case .calendar:
            return UITableView.automaticDimension
        case .detailTable:
            return 68
        }
    }
}


// MARK: - Extension: 달력셀에서 눌린 날짜를 가져다가 데이터 가져오기
extension DetailCalendarViewController: DetailCalendarCellDelegate {
    func calendarCellDidSelectDate(_ date: Date) {
        self.selectedDate = date
        applyFilter()
    }
}


// MARK: - Extension: 네비게이션
extension DetailCalendarViewController {
    
    // 네비게이션 타이틀 설정
    private func configureNavigaiton() {
        let titleLabel: UILabel = UILabel()
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.text = "🗒️ 일별 수입/지출 내역"
        titleLabel.font = UIFont(name: "OTSBAggroB", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.sizeToFit()
        
        self.navigationItem.titleView = titleLabel
    }
}


// MARK: - Enum
enum DetailCalendar: Int, CaseIterable {
    case calendar
    case detailTable
    
    var tile: String {
        switch self {
        case .calendar:
            return "📆 달력"
        case .detailTable:
            return "📋 수입/지출 내역"
        }
    }
}
