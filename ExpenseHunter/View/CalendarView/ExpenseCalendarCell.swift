//
//  ExpenseCalendarCell.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/12/25.
//

import UIKit

class ExpenseCalendarCell: UICollectionViewCell {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "ExpenseCalendarCell"
    private var selectedDate: Date = Date()      // 선택한 날짜
    
    
    // MARK: - UI Component
    private let calendarLabel: UILabel = UILabel()
    private let imageView: UIImageView = UIImageView()
    private let stackView: UIStackView = UIStackView()
    private let calendarView: UICalendarView = UICalendarView()
    private let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configureCalendarLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    private func setupUI() {
        contentView.backgroundColor = .clear
        
        calendarLabel.text = "일별 수입 / 지출 현황"
        calendarLabel.textColor = .label
        
        let config = UIImage.SymbolConfiguration(pointSize: 16)
        let chevronImage = UIImage(systemName: "chevron.forward", withConfiguration: config)
        imageView.image = chevronImage
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        
        stackView.addArrangedSubview(calendarLabel)
        stackView.addArrangedSubview(imageView)
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fill
        
        calendarView.locale = Locale(identifier: "ko")
        calendarView.layer.cornerRadius = 24
        calendarView.backgroundColor = .clear
        calendarView.calendar = .current
        calendarView.delegate = self
        
        // 단일 날짜 선택 동작지정
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
        
        // 초기 선택된 날짜 설정
        let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        selection.setSelected(today, animated: true)
        
        tableView.layer.cornerRadius = 8
        tableView.rowHeight = 48
        tableView.dataSource = self
        tableView.register(ExpenseSummaryCell.self, forCellReuseIdentifier: ExpenseSummaryCell.reuseIdentifier)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
    
        contentView.addSubview(stackView)
        contentView.addSubview(calendarView)
        contentView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            
            calendarView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 4),
            calendarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            calendarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            calendarView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -8),
            
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            tableView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configureCalendarLabel() {
        let fullText = "일별 수입 / 지출 현황"
        let attributedText = NSMutableAttributedString(string: fullText)
        
        if let incomeRange = fullText.range(of: "수입") {
            let nsRange = NSRange(incomeRange, in: fullText)
            attributedText.addAttributes([
                .foregroundColor: UIColor.systemGreen,
                .font: UIFont.systemFont(ofSize: 16, weight: .regular)
            ], range: nsRange)
        }
        
        if let expenseRange = fullText.range(of: "지출") {
            let nsRange = NSRange(expenseRange, in: fullText)
            attributedText.addAttributes([
                .foregroundColor: UIColor.systemRed,
                .font: UIFont.systemFont(ofSize: 16, weight: .regular)
            ], range: nsRange)
        }
        
        if let monthRange = fullText.range(of: "일별") {
            let nsRange = NSRange(monthRange, in: fullText)
            attributedText.addAttributes([
                .font: UIFont.systemFont(ofSize: 20, weight: .semibold)
            ], range: nsRange)
        }
        
        if let statusRange = fullText.range(of: "현황") {
            let nsRange = NSRange(statusRange, in: fullText)
            attributedText.addAttributes([
                .font: UIFont.systemFont(ofSize: 20, weight: .semibold)
            ], range: nsRange)
        }
        
        calendarLabel.attributedText = attributedText
    }
}


// MARK: - Extension: 달력 설정
extension ExpenseCalendarCell: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let selected = dateComponents?.date else { return }
        selectedDate = selected
        print("📅 Selected date: \(selected)")
        
        // ✅ Date → DateComponents 변환
        let calendar = Calendar.current
        let component = calendar.dateComponents([.year, .month, .day], from: selected)
        
        // ✅ 캘린더 데코레이션 갱신
        calendarView.reloadDecorations(forDateComponents: [component], animated: true)
    }
}


// MARK: - Extension: 테이블 뷰 설정
extension ExpenseCalendarCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseSummaryCell.reuseIdentifier, for: indexPath) as? ExpenseSummaryCell else { return UITableViewCell() }
        return cell
    }
}
