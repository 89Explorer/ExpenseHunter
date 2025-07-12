//
//  SummaryCardView.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/11/25.
//

import UIKit


class SummaryCardView: UIView {
    
    
    // MARK: - Variable
    private var isExpanded: Bool = false {
        didSet {
            updateExpandCollapse()
        }
    }
    
    // tableView의 높이 관리 프로퍼티
    private var tableViewHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - UI Component
    private let titleLabel: UILabel = UILabel()
    private let amountLabel: UILabel = UILabel()
    private let toggleButton: UIButton = UIButton(type: .system)
    private let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    private let moreButton: UIButton = UIButton(type: .system)
    
    
    // MARK: - Init
    init(title: String, color: UIColor) {
        super.init(frame: .zero)
        setupUI(title: title, color: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    private func setupUI(title: String, color: UIColor) {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 4)
        
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = color
        
        amountLabel.text = "₩ 30,000,000"
        amountLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        amountLabel.textAlignment = .right
        amountLabel.textColor = color
        
        toggleButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        toggleButton.tintColor = .label
        toggleButton.addTarget(self, action: #selector(toggleExpanded), for: .touchUpInside)
        
        moreButton.setTitle("더보기", for: .normal)
        moreButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        moreButton.setTitleColor(.secondaryLabel, for: .normal)
        moreButton.isHidden = true
        
        //tableView.isHidden = true
        tableView.layer.cornerRadius = 8
        tableView.rowHeight = 48
        tableView.dataSource = self
        tableView.register(ExpenseSummaryCell.self, forCellReuseIdentifier: ExpenseSummaryCell.reuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let headerStack = UIStackView(arrangedSubviews: [titleLabel, toggleButton])
        headerStack.axis = .horizontal
        headerStack.spacing = 8
        headerStack.distribution = .equalSpacing
        
        let totalStack = UIStackView(arrangedSubviews: [headerStack, amountLabel, tableView, moreButton])
        totalStack.axis = .vertical
        totalStack.spacing = 8
        totalStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(totalStack)
        NSLayoutConstraint.activate([
            totalStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            totalStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            totalStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            totalStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
        
        // tableView의 높이 제한
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint.isActive = true
    }
    
    
    // toggleButton에 따라 tableView와 moreButton이 나오게 하는 메서드
    private func updateExpandCollapse() {
        
        let icon = isExpanded ? "chevron.up" : "chevron.down"
        toggleButton.setImage(UIImage(systemName: icon), for: .normal)
        
        // 기본 높이 계산 (rowHeight x row 수)
        let targetHeight = isExpanded ? tableView.rowHeight * 4 : 0
        
        tableViewHeightConstraint.constant = targetHeight
        
        UIView.animate(withDuration: 0.25) {
            //self.tableView.isHidden = !self.isExpanded
            self.moreButton.isHidden = !self.isExpanded
            self.layoutIfNeeded()     // 뷰 자체 레이아웃 다시 계산해서 height 반영
        }
    }
    
    
    // MARK: - Action Method
    @objc private func toggleExpanded() {
        isExpanded.toggle()
    }
}


// MARK: - Extension: 최근 거래 최대 5건 보여주는 테이블뷰 설정
extension SummaryCardView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 4 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        cell.textLabel?.text = "2025-07-01 \(indexPath.row) | ₩100,000"
//        cell.textLabel?.font = .systemFont(ofSize: 13)
//        return cell
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseSummaryCell.reuseIdentifier, for: indexPath) as? ExpenseSummaryCell else { return UITableViewCell() }
        return cell
    }
}
