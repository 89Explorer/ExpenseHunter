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
    private let calendarView: UICalendarView = UICalendarView()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    private func setupUI() {
        calendarView.locale = Locale(identifier: "ko")
        calendarView.layer.cornerRadius = 24
        calendarView.backgroundColor = .clear
        calendarView.calendar = .current
        calendarView.delegate = self
        calendarView.translatesAutoresizingMaskIntoConstraints = false
    
        contentView.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            calendarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            calendarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            calendarView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
}


// MARK: - Extension: 달력 설정
extension ExpenseCalendarCell: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let selected = dateComponents?.date else { return }
        selectedDate = selected
        print("📅 Selected date: \(selected)")
    }
}
