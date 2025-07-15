//
//  ExpenseSummaryCell.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/11/25.
//

import UIKit

class ExpenseSummaryCell: UITableViewCell {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "ExpenseSummaryCell"

    
    // MARK: - UI Component
    private let dateLabel: UILabel = UILabel()
    private let sortLabel: UILabel = UILabel()
    private let expenseLabel: UILabel = UILabel()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    private func setupUI() {
        dateLabel.text = getFormattedDate()
        dateLabel.textColor = .label
        dateLabel.font = .systemFont(ofSize: 10, weight: .bold)
        
        sortLabel.text = "근로소득"
        sortLabel.font = UIFont(name: "SB_OTF_B", size: 10)
        sortLabel.textColor = .secondaryLabel
        //sortLabel.font = .systemFont(ofSize: 10, weight: .semibold)
        
        let stackView = UIStackView(arrangedSubviews: [dateLabel, sortLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill
        
        expenseLabel.text = "₩ 100,000원"
        expenseLabel.font = .systemFont(ofSize: 16, weight: .bold)
        expenseLabel.textAlignment = .right
        
        let totalStackView = UIStackView(arrangedSubviews: [stackView, expenseLabel])
        totalStackView.axis = .horizontal
        totalStackView.spacing = 12
        totalStackView.alignment = .fill
        
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(totalStackView)
        
        NSLayoutConstraint.activate([
            totalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            totalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            totalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            totalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    // 2025-07-11 형식으로 String 타입으로 날짜를 반환하는 함수 
    private func getFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

}
