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
    var onMoreTapped: (() -> Void)?
    
    
    // MARK: - UI Component
    private let titleLabel: UILabel = UILabel()
    private let moreButton: UIButton = UIButton(type: .custom)
    
    
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
        
        let moreTitle = NSLocalizedString("see_more", comment: "Button title for 'See more' action")
        moreButton.setTitle(moreTitle, for: .normal)
        moreButton.setTitleColor(.label, for: .normal)
        moreButton.titleLabel?.font = UIFont(name: "Ownglyph_daelong-Rg", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
        //moreButton.backgroundColor = .systemCyan
        moreButton.layer.cornerRadius = 8
        moreButton.clipsToBounds = true
        moreButton.contentEdgeInsets = .init(top: 4, left: 4, bottom: 4, right: 4)
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(moreButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            moreButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(title: String, showMore: Bool = true) {
        titleLabel.text = title
        moreButton.isHidden = !showMore
    }
    
    
    // MARK: - Action Method
    @objc private func moreButtonTapped() {
        onMoreTapped?()
    }
}
