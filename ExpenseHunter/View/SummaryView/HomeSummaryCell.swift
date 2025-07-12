//
//  HomeSummaryCell.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/11/25.
//

import UIKit


class HomeSummaryCell: UICollectionViewCell {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "HomeSummaryCell"
    private var selectedMonth: Int = Calendar.current.component(.month, from: Date()) {
        didSet {
            updateMonthButtonTitle()
        }
    }
    
    var isMenuOpen: Bool = false {
        didSet {
            updateMonthButtonTitle()
        }
    }
    
    
    
    // MARK: - UI Component
    private let monthButton: UIButton = UIButton(type: .system)
    private let imageView: UIImageView = UIImageView()
    private let stackView: UIStackView = UIStackView()
    private let incomeCardView: SummaryCardView = SummaryCardView(title: "수입", color: .systemGreen)
    private let expenseCardView: SummaryCardView = SummaryCardView(title: "지출", color: .systemRed)
    private let totalCardStack: UIStackView = UIStackView()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        updateMonthButtonTitle()
        updateMonthMenu()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    private func setupUI() {
        contentView.backgroundColor = .clear

        monthButton.showsMenuAsPrimaryAction = true
        monthButton.contentHorizontalAlignment = .left
        monthButton.setTitleColor(.label, for: .normal)
        
        let config = UIImage.SymbolConfiguration(pointSize: 16)
        let chevronImage = UIImage(systemName: "chevron.forward", withConfiguration: config)
        imageView.image = chevronImage
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        
        stackView.addArrangedSubview(monthButton)
        stackView.addArrangedSubview(imageView)
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fill
        
        contentView.addSubview(stackView)
        contentView.addSubview(incomeCardView)
        contentView.addSubview(expenseCardView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        incomeCardView.translatesAutoresizingMaskIntoConstraints = false
        expenseCardView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            
            incomeCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            incomeCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            incomeCardView.topAnchor.constraint(equalTo: monthButton.bottomAnchor, constant: 4),
            incomeCardView.bottomAnchor.constraint(equalTo: expenseCardView.topAnchor, constant: -12),
            
            expenseCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            expenseCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4)
        ])
    }
    
    // monthButton에 월 표시하기 위한 설정
    private func updateMonthButtonTitle() {
        let fullText = "\(selectedMonth)월 수입 / 지출 현황"
        let attributedString = NSMutableAttributedString(string: fullText)

        if let incomeRange = fullText.range(of: "수입") {
            attributedString.addAttribute(.foregroundColor, value: UIColor.systemGreen, range: NSRange(incomeRange, in: fullText))
        }
        if let expenseRange = fullText.range(of: "지출") {
            attributedString.addAttribute(.foregroundColor, value: UIColor.systemRed, range: NSRange(expenseRange, in: fullText))
        }
        if let statusRange = fullText.range(of: "수입 / 지출") {
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(statusRange, in: fullText))
        }
        if let monthRange = fullText.range(of: "\(selectedMonth)월") {
            let nsRange = NSRange(monthRange, in: fullText)
            attributedString.addAttributes([
                .font: UIFont.systemFont(ofSize: 20, weight: .semibold)
            ], range: nsRange)
        }

        if let statusRange = fullText.range(of: "현황") {
            let nsRange = NSRange(statusRange, in: fullText)
            attributedString.addAttributes([
                .font: UIFont.systemFont(ofSize: 20, weight: .semibold)
            ], range: nsRange)
        }
        monthButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    // contextMenu에 1월 ~ 12월 항목 및 선택에 따른 데이터 필터링 설정
    private func updateMonthMenu() {
        let actions = (1...12).map { month in
            UIAction(
                title: "\(month)월",
                state: month == selectedMonth ? .on : .off
            ) { [weak self] _ in
                self?.selectedMonth = month
                self?.updateMonthButtonTitle()
                self?.updateMonthMenu()
                // TODO: 필요한 경우 여기서 수입/지출 카드도 업데이트
            }
        }
        let menu = UIMenu(title: "월 선택", options: .displayInline, children: actions)
        monthButton.menu = menu
    }
}
