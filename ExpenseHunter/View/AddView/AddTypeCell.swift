//
//  AddTypeCell.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/16/25.
//

import UIKit

class AddTypeCell: UITableViewCell {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "AddTypeCell"
    weak var delegate: AddTypeCellDelegate?
    
    private var selectedType: TransactionType? = .expense {
        didSet {
            updateUI()
        }
    }
    
    
    // MARK: - UI Component
    private let incomeButton: UIButton = UIButton()
    private let expenseButton: UIButton = UIButton()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    private func configureUI() {
        contentView.backgroundColor = .clear
        
        incomeButton.setTitle("📥 수입", for: .normal)
        incomeButton.titleLabel?.font = UIFont(name: "OTSBAggroB", size: 16)
        incomeButton.setTitleColor(.systemGreen, for: .normal)
        incomeButton.backgroundColor = .secondarySystemBackground
        incomeButton.layer.cornerRadius = 8
        incomeButton.layer.borderWidth = 1.0
        incomeButton.layer.borderColor = UIColor.systemGreen.cgColor
        incomeButton.tag = 0
        
        expenseButton.setTitle("📤 지출", for: .normal)
        expenseButton.titleLabel?.font = UIFont(name: "OTSBAggroB", size: 16)
        expenseButton.setTitleColor(.systemRed, for: .normal)
        expenseButton.backgroundColor = .secondarySystemBackground
        expenseButton.layer.cornerRadius = 8
        expenseButton.layer.borderWidth = 1.0
        expenseButton.layer.borderColor = UIColor.systemRed.cgColor
        expenseButton.tag = 1
        
        let stackView = UIStackView(arrangedSubviews: [incomeButton, expenseButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 12
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    private func updateUI() {
        // incomeButton
        if selectedType == .income {
            incomeButton.setTitleColor(.systemGreen, for: .normal)
            incomeButton.layer.borderColor = UIColor.systemGreen.cgColor
        } else {
            incomeButton.setTitleColor(.label, for: .normal)
            incomeButton.layer.borderColor = UIColor.clear.cgColor
        }

        // expenseButton
        if selectedType == .expense {
            expenseButton.setTitleColor(.systemRed, for: .normal)
            expenseButton.layer.borderColor = UIColor.systemRed.cgColor
        } else {
            expenseButton.setTitleColor(.label, for: .normal)
            expenseButton.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    private func configureAction() {
        incomeButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        expenseButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    func configure(selectedType: TransactionType?) {
        self.selectedType = selectedType
    }
    
    
    // MARK: - Action Method
    @objc private func buttonTapped(_ sender: UIButton) {
        selectedType = sender.tag == 0 ? .income : .expense
        delegate?.didSelectTransactionType(selectedType!)
    }
}


// MARK: - Protocol: 버튼의 선택에 따라 버튼 설정을 달리 할 수 있도록 델리게이트 패턴
protocol AddTypeCellDelegate: AnyObject {
    func didSelectTransactionType(_ type: TransactionType)
}
