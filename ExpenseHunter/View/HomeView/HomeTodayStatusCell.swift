//
//  HomeTodayStatusCell.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/16/25.
//

import UIKit

class HomeTodayStatusCell: UITableViewCell {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "HomeTodayStatusCell"
    
    
    // MARK: - UI Component
    private let containerView: UIView = UIView()
    private let statusImageView: UIImageView = UIImageView()
    private let titleLabel: UILabel = UILabel()
    private let categoryLabel: UILabel = UILabel()
    private let amountLabel: UILabel = UILabel()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Component
    private func configureUI() {
        contentView.backgroundColor = .clear
        
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 8
        
        statusImageView.image = UIImage(systemName: "fork.knife")
        statusImageView.tintColor = .label
        statusImageView.contentMode = .scaleAspectFit
        statusImageView.backgroundColor = UIColor.systemGray6
        statusImageView.layer.cornerRadius = 12
        statusImageView.clipsToBounds = true
        
        titleLabel.text = "편의점 털기"
        titleLabel.font = UIFont(name: "OTSBAggroB", size: 12)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        
        categoryLabel.text = "쇼핑"
        categoryLabel.font = UIFont(name: "OTSBAggroL", size: 10)
        categoryLabel.textColor = .secondaryLabel
        categoryLabel.numberOfLines = 1
        
        amountLabel.text = "- ₩ 16,500"
        amountLabel.font = UIFont(name: "OTSBAggroL", size: 16)
        amountLabel.textColor = .systemRed
        amountLabel.numberOfLines = 1
        amountLabel.textAlignment = .right
        amountLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        let innerStackView: UIStackView = UIStackView(arrangedSubviews: [titleLabel, categoryLabel])
        innerStackView.axis = .vertical
        innerStackView.spacing = 4
        innerStackView.alignment = .fill
        
        
        let totalStackView: UIStackView = UIStackView(arrangedSubviews: [statusImageView, innerStackView, amountLabel])
        totalStackView.axis = .horizontal
        totalStackView.spacing = 12
        totalStackView.alignment = .center
        totalStackView.distribution = .fill
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        contentView.addSubview(containerView)
        containerView.addSubview(totalStackView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            statusImageView.widthAnchor.constraint(equalToConstant: 40),
            statusImageView.heightAnchor.constraint(equalToConstant: 40),
            
            totalStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            totalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            totalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            totalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
        ])
    }
}
