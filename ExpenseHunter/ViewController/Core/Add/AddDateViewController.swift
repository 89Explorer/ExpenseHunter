//
//  AddDateViewController.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/16/25.
//

import UIKit

class AddDateViewController: UIViewController {
    
    
    // MARK: - Variable
    private var selectedDate: Date = Date()
    
    // 선택한 날짜를 전달하기 위한 프로퍼티
    var onDateSelected: ((Date) -> Void)?
    
    
    // MARK: - UI Component
    private let calendarView: UICalendarView = UICalendarView()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    
    // MARK: - Function
    private func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        
        calendarView.locale = Locale(identifier: "ko")
        calendarView.layer.cornerRadius = 16
        calendarView.backgroundColor = .clear
        calendarView.calendar = .current
        calendarView.delegate = self
        
        // 단일 날짜 선택 동작지정
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
        
        // 초기 선택된 날짜 설정
        //        let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        //        selection.setSelected(today, animated: true)
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarView)
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4)
        ])
    }
}

// MARK: - Extension: 달력설정
extension AddDateViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let selected = dateComponents?.date else { return }
        self.selectedDate = selected
        print("📅 Selected date: \(selected)")
        
        // ✅ Date → DateComponents 변환
        let calendar = Calendar.current
        let component = calendar.dateComponents([.year, .month, .day], from: selected)
        // ✅ 캘린더 데코레이션 갱신
        calendarView.reloadDecorations(forDateComponents: [component], animated: true)
        onDateSelected?(selected)
        dismiss(animated: true)
    }

}
