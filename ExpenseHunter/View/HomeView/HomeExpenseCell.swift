//
//  HomeExpenseCell.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/15/25.
//

import UIKit

class HomeExpenseCell: UITableViewCell {
    
    // MARK: - Variable
    static let reuseIdentifier: String = "HomeExpenseCell"
    
    
    // MARK: - UI Component
    private let containerView: UIView = UIView()
    private let titleLabel: BasePaddingLabel = BasePaddingLabel()
    private let amountLabel: BasePaddingLabel = BasePaddingLabel()
    
    
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
        contentView.backgroundColor = .clear
        
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 8
//        containerView.layer.shadowColor = UIColor.label.cgColor
//        containerView.layer.shadowOpacity = 0.5
//        containerView.layer.shadowOffset = CGSize(width: 4, height: 8)
//        containerView.layer.shadowRadius = 4
//        containerView.layer.masksToBounds = false
        
        titleLabel.text = "이번 달, 수입"
        titleLabel.font = UIFont(name: "OTSBAggroB", size: 20)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        
        amountLabel.text = "₩ 3,500,000"
        amountLabel.font = UIFont(name: "OTSBAggroB", size: 32)
        amountLabel.textColor = .label
        amountLabel.numberOfLines = 0

        let stackView: UIStackView = UIStackView(arrangedSubviews: [titleLabel, amountLabel])
        
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
        ])
    }
    
    func configure(with title: String, amount: Int, type: TransactionType) {
        titleLabel.text = title
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.locale = Locale(identifier: "ko")
        
        let formattedAmount = formatter.string(from: NSNumber(value: amount))
        amountLabel.text = "₩ \(formattedAmount ?? "0") 원"
        
        if type == .income {
            //containerView.backgroundColor = .systemGreen.withAlphaComponent(0.1)
            amountLabel.textColor = .systemGreen
        } else if type == .expense {
            //containerView.backgroundColor = .systemRed.withAlphaComponent(0.1)
            amountLabel.textColor = .systemRed
        }
    }

}
