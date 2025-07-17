//
//  AddCustomCell.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/16/25.
//

import UIKit

class AddCustomCell: UITableViewCell {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "AddDateCell"
    weak var delegate: AddCustomCellDelegate?
    var onValueLabelTapped: (() -> Void)?
    
    
    // MARK: - UI Component
    private let titleLabel: UILabel = UILabel()
    private let valueLabel: UILabel = UILabel()
    private let seperator: UIView = UIView()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        valueLabel.text = ""
        seperator.backgroundColor = .secondaryLabel
    }
    
    
    // MARK: - Function
    private func configureUI() {
        contentView.backgroundColor = .clear
        
        titleLabel.text = "날짜"
        titleLabel.font = UIFont(name: "OTSBAggroB", size: 16)
        titleLabel.textColor = .label
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        valueLabel.text = ""
        valueLabel.font = UIFont(name: "OTSBAggroB", size: 12)
        valueLabel.textColor = .label
        valueLabel.numberOfLines = 0
        valueLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        valueLabel.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(valueLabelDidTapped))
        valueLabel.addGestureRecognizer(tapGesture)
        
        seperator.backgroundColor = .systemRed
        
        let innerStack: UIStackView = UIStackView(arrangedSubviews: [valueLabel, seperator])
        innerStack.axis = .vertical
        innerStack.spacing = 2
        innerStack.distribution = .fill
        innerStack.alignment = .fill
        
        let totalStack: UIStackView = UIStackView(arrangedSubviews: [titleLabel, innerStack])
        totalStack.axis = .horizontal
        totalStack.spacing = 20
        totalStack.distribution = .fill
        
        totalStack.translatesAutoresizingMaskIntoConstraints = false
        seperator.translatesAutoresizingMaskIntoConstraints = false 
        
        contentView.addSubview(totalStack)
        
        NSLayoutConstraint.activate([
            totalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            totalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            totalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            totalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            seperator.heightAnchor.constraint(equalToConstant: 2),
            seperator.widthAnchor.constraint(equalTo: valueLabel.widthAnchor)
        ])
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    // addType에 따라 seperator 색상 변경
    func updateSeparatorColor(isSelected: Bool, transactionType: TransactionType) {
        if isSelected {
            switch transactionType {
            case .income:
                seperator.backgroundColor = .systemGreen
            case .expense:
                seperator.backgroundColor = .systemRed
            }
        } else {
            seperator.backgroundColor = .secondaryLabel
        }
    }

    // MARK: - Action Method
    @objc private func valueLabelDidTapped() {
        delegate?.valueLabelTapped(in: self)
        onValueLabelTapped?()
    }
}


extension AddCustomCell {
    
    // AddDateViewController에서 선택한 달력을 받는 메서드 구현
    // AddCustomCell에 날짜 문자열을 외부에서 설정할 수 있도록 해주는 메서드
    func updateDateValue(with date: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd (E)"
        let formatted = formatter.string(from: date)
        valueLabel.text = formatted
    }
    
    // AddAmountViewController 내에 선택한 금액을 전달하는 메서드 
    func updateAmountValue(with amount: Int) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        valueLabel.text = "₩ \(formatter.string(from: NSNumber(value: amount)) ?? "0")"
    }
    
}



// MARK: - Protocol: 각 valueLabel을 눌렀을 때 동작하는 기능 구현
protocol AddCustomCellDelegate: AnyObject {
    func valueLabelTapped(in cell: AddCustomCell)
}
