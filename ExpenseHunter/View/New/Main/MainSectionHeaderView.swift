//
//  MainSectionHeaderView.swift
//  ExpenseHunter
//
//  Created by 권정근 on 8/14/25.
//

import UIKit

class MainSectionHeaderView: UICollectionReusableView {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "MainSectionHeaderView"
    
    
    // MARK: - UI Component
    private let titleLabel: UILabel = UILabel()
    
    
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
        backgroundColor = .clear
        
        titleLabel.font = UIFont(name: "Ownglyph_daelong-Rg", size: 28) ?? UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
