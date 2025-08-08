//
//  DetailCalendarCell.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/24/25.
//

import UIKit

class DetailCalendarCell: UITableViewCell {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "DetailCalendarCell"
    private var selectedDate: Date = Date()
    weak var delegate: DetailCalendarCellDelegate?
    
    
    // MARK: - UI Component
    private let calendarView: UICalendarView = UICalendarView()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    private func configureUI() {
        backgroundColor = .clear
        
        //calendarView.locale = Locale(identifier: "ko")
        calendarView.locale = Locale.current
        calendarView.backgroundColor = .systemBackground
        calendarView.layer.cornerRadius = 12
        calendarView.layer.masksToBounds = true
        calendarView.calendar = .current
        calendarView.delegate = self
        
        // 단일 날짜 선택 동작지정
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
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
extension DetailCalendarCell: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let selected = dateComponents?.date else { return }
        selectedDate = selected
        print("📅 Selected date: \(selected)")
        delegate?.calendarCellDidSelectDate(selected)
        
        // ✅ Date → DateComponents 변환
        let calendar = Calendar.current
        let component = calendar.dateComponents([.year, .month, .day], from: selected)
        
        // ✅ 캘린더 데코레이션 갱신
        calendarView.reloadDecorations(forDateComponents: [component], animated: true)
    }
}


// MARK: - Protocol: 캘린더 뷰에서 날짜를 선택하고 이를 전달하기 위한 델리게이트 패턴
protocol DetailCalendarCellDelegate: AnyObject {
    func calendarCellDidSelectDate(_ date: Date)
}

