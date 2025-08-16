//
//  AddCategroyCell.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/20/25.
//

import UIKit

class AddCategroyCell: UICollectionViewCell {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "AddCategroyCell"
    
    
    // MARK: - UI Component
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    private func configureUI() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 12
        contentView.layer.borderColor = UIColor.label.cgColor
        contentView.layer.borderWidth = 1.0
        
        iconView.tintColor = .label
        iconView.contentMode = .scaleAspectFit
        //iconView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont(name: "OTSBAggroB", size: 16)
        titleLabel.textAlignment = .center
        //titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [iconView, titleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(title: String, iconSystemName: String) {
        titleLabel.text = title
        iconView.image = UIImage(named: iconSystemName)
    }
}
