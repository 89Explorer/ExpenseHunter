//
//  MainBreakdownCell.swift
//  ExpenseHunter
//
//  Created by 권정근 on 8/14/25.
//

import UIKit

class MainBreakdownCell: UICollectionViewCell {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "MainBreakdownCell"
    
    
    // MARK: - UI Component
    private let containerView: UIView = UIView()
    private let statutsImage: UIImageView = UIImageView()
    private let categoryLabel: UILabel = UILabel()
    private let memoImageView: UIImageView = UIImageView()
    private let photoImageView: UIImageView = UIImageView()
    private let dateLabel: UILabel = UILabel()
    private let amountLabel: UILabel = UILabel()
    
    
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
        
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 8
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        statutsImage.image = UIImage(systemName: "fork.knife")
        statutsImage.tintColor = .systemGreen
        statutsImage.contentMode = .scaleAspectFit
        statutsImage.backgroundColor = UIColor.systemGray6
        statutsImage.layer.cornerRadius = 8
        statutsImage.clipsToBounds = true
        statutsImage.translatesAutoresizingMaskIntoConstraints = false
        
        categoryLabel.text = "카드 대금"
        categoryLabel.font = UIFont(name: "Ownglyph_daelong-Rg", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .regular)
        categoryLabel.textColor = .label
        categoryLabel.numberOfLines = 1
        categoryLabel.textAlignment = .left
        
        memoImageView.image = UIImage(systemName: "newspaper.circle")
        memoImageView.tintColor = .label
        memoImageView.contentMode = .scaleAspectFit
        memoImageView.backgroundColor = UIColor.systemGray6
        memoImageView.layer.cornerRadius = 8
        memoImageView.clipsToBounds = true
        memoImageView.isHidden = false
        memoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        photoImageView.image = UIImage(systemName: "photo.circle")
        photoImageView.tintColor = .label
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.backgroundColor = UIColor.systemGray6
        photoImageView.layer.cornerRadius = 8
        photoImageView.clipsToBounds = true
        photoImageView.isHidden = false
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.text = "2일전"
        dateLabel.font = UIFont(name: "Ownglyph_daelong-Rg", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
        dateLabel.textColor = .secondaryLabel
        dateLabel.textAlignment = .center
        dateLabel.numberOfLines = 1
        
        amountLabel.text = "₩ 1,060,000"
        amountLabel.font = UIFont(name: "Ownglyph_daelong-Rg", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .regular)
        amountLabel.textColor = .label
        amountLabel.numberOfLines = 1
        amountLabel.textAlignment = .right
        //amountLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        let innerStackView: UIStackView = UIStackView(arrangedSubviews: [memoImageView, photoImageView])
        innerStackView.axis = .horizontal
        innerStackView.spacing = 4
        innerStackView.distribution = .fill
        //innerStackView.alignment = .fill
        //innerStackView.setContentHuggingPriority(.required, for: .horizontal)
        
        let middleStackView: UIStackView = UIStackView(arrangedSubviews: [innerStackView, dateLabel])
        middleStackView.axis = .horizontal
        middleStackView.spacing = 8
        middleStackView.alignment = .center
        middleStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let totalStackView: UIStackView = UIStackView(arrangedSubviews: [categoryLabel, middleStackView, amountLabel])
        totalStackView.axis = .horizontal
        totalStackView.spacing = 12
        totalStackView.distribution = .fill
        //totalStackView.alignment = .fill
        //totalStackView.isLayoutMarginsRelativeArrangement = true
        //totalStackView.layoutMargins = .zero
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(containerView)
        containerView.addSubview(statutsImage)
        containerView.addSubview(totalStackView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            statutsImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            statutsImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            statutsImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            statutsImage.widthAnchor.constraint(equalToConstant: 28),
            //statutsImage.heightAnchor.constraint(equalTo: statutsImage.widthAnchor),
            
            
            memoImageView.widthAnchor.constraint(equalToConstant: 20),
            memoImageView.heightAnchor.constraint(equalTo: memoImageView.widthAnchor),
            
            photoImageView.widthAnchor.constraint(equalToConstant: 20),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor),
            
            totalStackView.leadingAnchor.constraint(equalTo: statutsImage.trailingAnchor, constant: 8),
            totalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            totalStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            totalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            
            middleStackView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
    }
    
}
