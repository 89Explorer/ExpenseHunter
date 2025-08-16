//
//  MoreMonthCell.swift
//  ExpenseHunter
//
//  Created by 권정근 on 8/12/25.
//

import UIKit

class MoreMonthCell: UICollectionViewCell {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "MoreMonthCell"
    
    
    // MARK: - UI Component
    private let containerView: UIView = UIView()
    private let monthLabel: UILabel = UILabel()
    private let numberLabel: UILabel = UILabel()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        monthLabel.text = nil
        numberLabel.text = nil
    }
    
    
    // MARK: - Function
    private func configureUI() {
        contentView.backgroundColor = .clear
        
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        monthLabel.font = UIFont(name: "Ownglyph_daelong-Rg", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
        monthLabel.textAlignment = .center
        
        numberLabel.font = UIFont(name: "Ownglyph_daelong-Rg", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
        numberLabel.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [monthLabel, numberLabel])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(containerView)
        containerView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            monthLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            monthLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            //stack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            //stack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    func configure(with item: MonthItem, isSelected: Bool) {
        monthLabel.text = item.shortName
        //numberLabel.text  = "\(item.number)"
        
        containerView.backgroundColor = isSelected ? .systemBlue : .secondarySystemBackground
        monthLabel.textColor = isSelected ? .label : .secondaryLabel
        monthLabel.font = isSelected ? UIFont(name: "OTSBAggroB", size: 16) : UIFont(name: "OTSBAggroB", size: 12)
        
        numberLabel.textColor = isSelected ? .label: .secondaryLabel
        numberLabel.font = isSelected ? UIFont(name: "OTSBAggroB", size: 16) : UIFont(name: "OTSBAggroB", size: 12)
    }
}


// MARK: - Struct 월 표시 구조체
struct MonthItem {
    let shortName: String // "Jan"
    let number: Int       // 1
}
