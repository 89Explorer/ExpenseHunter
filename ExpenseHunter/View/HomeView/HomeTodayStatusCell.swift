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
    private let memoImageView: UIImageView = UIImageView()
    private let photoImageView: UIImageView = UIImageView()
    private let amountLabel: UILabel = UILabel()
    private let leftSpacer = UIView()
    private let rightSpacer = UIView()
    
    
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
        
        categoryLabel.text = "카드대금"
        categoryLabel.font = UIFont(name: "OTSBAggroL", size: 16)
        categoryLabel.textColor = .label
        categoryLabel.numberOfLines = 1
        
        memoImageView.image = UIImage(systemName: "newspaper.circle")
        memoImageView.tintColor = .label
        memoImageView.contentMode = .scaleAspectFit
        memoImageView.backgroundColor = UIColor.systemGray6
        memoImageView.layer.cornerRadius = 12
        memoImageView.clipsToBounds = true
        memoImageView.isHidden = false
        
        photoImageView.image = UIImage(systemName: "photo.circle")
        photoImageView.tintColor = .label
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.backgroundColor = UIColor.systemGray6
        photoImageView.layer.cornerRadius = 12
        photoImageView.clipsToBounds = true
        photoImageView.isHidden = false
        
        amountLabel.text = "- ₩ 160,000"
        amountLabel.font = UIFont(name: "OTSBAggroL", size: 16)
        amountLabel.textColor = .systemRed
        amountLabel.numberOfLines = 1
        amountLabel.textAlignment = .right
        amountLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        let innerStackView: UIStackView = UIStackView(arrangedSubviews: [memoImageView, photoImageView])
        innerStackView.axis = .horizontal
        innerStackView.spacing = 8
        innerStackView.distribution = .fill
        innerStackView.alignment = .fill
        
        let totalStackView: UIStackView = UIStackView(arrangedSubviews: [statusImageView, categoryLabel, amountLabel])
        totalStackView.axis = .horizontal
        totalStackView.spacing = 12
        totalStackView.alignment = .center
        totalStackView.distribution = .fill
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        innerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        contentView.addSubview(containerView)
        containerView.addSubview(totalStackView)
        containerView.addSubview(innerStackView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            statusImageView.widthAnchor.constraint(equalToConstant: 40),
            statusImageView.heightAnchor.constraint(equalToConstant: 40),
            
            memoImageView.widthAnchor.constraint(equalToConstant: 28),
            memoImageView.heightAnchor.constraint(equalToConstant: 28),
            
            photoImageView.widthAnchor.constraint(equalToConstant: 28),
            photoImageView.heightAnchor.constraint(equalToConstant: 28),
            
            totalStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            totalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            totalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            totalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
            
            innerStackView.centerYAnchor.constraint(equalTo: totalStackView.centerYAnchor),
            innerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 136)
        ])
    }
    
    func configure(with data: ExpenseModel) {
        let category = data.category
        categoryLabel.text = category
        
        let type = data.transaction
        if let systemName = type.categoryImageMap[category] {
            statusImageView.image = UIImage(systemName: systemName)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.locale = Locale(identifier: "ko")
        
        let formattedAmount = formatter.string(from: NSNumber(value: data.amount))
        
        if type == .income {
            //containerView.backgroundColor = .systemGreen.withAlphaComponent(0.1)
            amountLabel.textColor = .systemGreen
            amountLabel.text = "+ ₩ \(formattedAmount ?? "0") 원"
        } else if type == .expense {
            //containerView.backgroundColor = .systemRed.withAlphaComponent(0.1)
            amountLabel.textColor = .systemRed
            amountLabel.text = "- ₩ \(formattedAmount ?? "0") 원"
        }

        memoImageView.tintColor = ((data.memo?.count) == 0) ? UIColor.secondaryLabel : UIColor.label
        photoImageView.tintColor = (data.image == nil) ? UIColor.secondaryLabel : UIColor.label
        
    }
}
