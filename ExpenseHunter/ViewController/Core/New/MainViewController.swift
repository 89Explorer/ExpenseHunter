//
//  MainViewController.swift
//  ExpenseHunter
//
//  Created by 권정근 on 8/13/25.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    
    // MARK: - Variable
    private let transactionViewModel: TransactionViewModel = TransactionViewModel()
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    
    // MARK: - UI Component
    private var mainCollectionView: UICollectionView!
    private let floatingButton: UIButton = UIButton(type: .custom)
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        transactionViewModel.readAllTransactions()
        transactionViewModel.setAllTransactions()
        transactionViewModel.checkAndGenerateRepeatedTransactionsIfNeeded()
        bindViewModel()
    }
    
    
    // MARK: - Function
    private func bindViewModel() {
        transactionViewModel.$transactions
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                
                guard let self else { return }
                
                self.mainCollectionView.reloadData()
                
            }
            .store(in: &cancellables)
    }
    
    private func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        
        mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        mainCollectionView.backgroundColor = .clear
        mainCollectionView.showsVerticalScrollIndicator = false
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        mainCollectionView.register(MainSummaryCell.self, forCellWithReuseIdentifier: MainSummaryCell.reuseIdentifier)
        mainCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        mainCollectionView.register(MainBreakdownCell.self, forCellWithReuseIdentifier: MainBreakdownCell.reuseIdentifier)
        
        mainCollectionView.register(
            MainSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MainSectionHeaderView.reuseIdentifier)
        
        
        let config = UIImage.SymbolConfiguration(pointSize: 28)
        let plusImage = UIImage(systemName: "plus", withConfiguration: config)
        floatingButton.setImage(plusImage, for: .normal)
        floatingButton.tintColor = .label
        floatingButton.backgroundColor = .systemBlue
        floatingButton.layer.cornerRadius = 28
        floatingButton.layer.shadowOpacity = 0.3
        floatingButton.layer.shadowRadius = 8
        floatingButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainCollectionView)
        view.addSubview(floatingButton)
        
        NSLayoutConstraint.activate([
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            mainCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            floatingButton.widthAnchor.constraint(equalToConstant: 56),
            floatingButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        
    }
    
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(40))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { [weak self] section, _ in
            guard let sectionType = MainCollectionViewSection(rawValue: section) else { fatalError("Section Error") }
            
            // 헤더를 생성하는 부분
            guard let sectionHeader = self?.createSectionHeader() else { fatalError("Section Error") }
            
            switch sectionType {
                
            case .summary:
                let itemSize =  NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(280))
                let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
                layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
                
                let layoutGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: itemSize,
                    subitems: [layoutItem]
                )
                
                let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
                //layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
                
                layoutSection.boundarySupplementaryItems = [sectionHeader]
                
                return layoutSection
                
            case .breakdown:
                // 1. 아이템 높이를 그룹 높이의 1/5로 설정
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0 / 5.0) // ✅ 그룹 높이의 1/5
                )
                let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
                layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
                
                // 2. 그룹 높이를 화면에 맞게 적절히 설정
                //    이 높이는 5개의 아이템 높이 + 여백을 포함해야 합니다.
                let groupHeight = 320.0 // 예시 높이. 실제로는 더 유동적으로 계산할 수 있습니다.
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0), // ✅ 그룹 너비를 화면 너비에 맞춤
                    heightDimension: .absolute(groupHeight) // ✅ 고정된 그룹 높이
                )
                
                // 3. 그룹에 아이템을 5개 넣기
                let layoutGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    subitems: Array(repeating: layoutItem, count: 5)
                )
                
                let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
                layoutSection.boundarySupplementaryItems = [sectionHeader]
                
                //layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
                return layoutSection
            }
        }
        
        // 🔹 섹션 간 간격 설정
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    
    // MARK: - Action Method
    @objc private func addButtonTapped(_ sender: UIButton) {
        let addTransactionVC = AddTransactionViewController(mode: .create)
        navigationController?.pushViewController(addTransactionVC, animated: true)
    }
}


// MARK: - Extension: UICollectionViewDelegate, UICollectionViewDataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return MainCollectionViewSection.allCases.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = MainCollectionViewSection(rawValue: section) else { return 1 }
        switch section {
        case .summary:
            return 1
        case .breakdown:
            return transactionViewModel.recentTransactions.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = MainCollectionViewSection(rawValue: indexPath.section) else { fatalError("Invalid section") }
        
        switch section {
        case .summary:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainSummaryCell.reuseIdentifier, for: indexPath) as? MainSummaryCell else { return UICollectionViewCell() }
            cell.configure(with: transactionViewModel.totalBalanceThisMonth,
                           income: transactionViewModel.totalInomeAmountThisMonth,
                           expense: transactionViewModel.totalExpenseAmountThisMonth,
                           incomeCount: transactionViewModel.totalIncomeCountThisMonth,
                           expenseCount: transactionViewModel.totalExpenseCountThisMonth,
                           incomeGraphData: transactionViewModel.incomeGraphData,
                           expenseGraphData: transactionViewModel.expenseGraphData
            )
            return cell
        case .breakdown:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainBreakdownCell.reuseIdentifier, for: indexPath) as? MainBreakdownCell else { return UICollectionViewCell() }
          
            let item = transactionViewModel.recentTransactions[indexPath.row]
            cell.configure(with: item)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = MainCollectionViewSection(rawValue: indexPath.section) else { fatalError("Invalid section")}
        
        switch section {
        case .summary:
            let detailVC = MoreChartViewController(type: .expense)
            navigationController?.pushViewController(detailVC, animated: true)
        case .breakdown:
            let id = transactionViewModel.recentTransactions[indexPath.row].id
            let editVC = AddTransactionViewController(mode: .edit(id: id))
            navigationController?.pushViewController(editVC, animated: true)
        }
    }
    
    // 헤더뷰 설정
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath)
    -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView()
        }
        
        guard let sectionType = MainCollectionViewSection(rawValue: indexPath.section) else { return UICollectionReusableView()
        }
        
        switch sectionType {
        case .summary:
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MainSectionHeaderView.reuseIdentifier,
                for: indexPath
            ) as! MainSectionHeaderView
            
            headerView.configure(title: sectionType.title, showMore: false)
            return headerView
        case .breakdown:
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MainSectionHeaderView.reuseIdentifier,
                for: indexPath
            ) as! MainSectionHeaderView
            
            headerView.configure(title: sectionType.title)
            headerView.onMoreTapped = {
                print("더 보기 눌림")
                
            }
            return headerView
        }
    }
}


// MARK: - Extension: 날짜 설정 메서드
extension MainViewController {
    
    // 네비게이션 바 부분에 날짜를 넣는 메서드
    private func configureNavigation() {
        
        // 네비게이션 배경색 설정
        //        let appearance = UINavigationBarAppearance()
        //        appearance.configureWithOpaqueBackground()
        //        appearance.backgroundColor = UIColor.secondarySystemBackground
        //appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        //appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        
        //        navigationItem.standardAppearance = appearance
        //        navigationItem.scrollEdgeAppearance = appearance
        //        navigationItem.compactAppearance = appearance
        
        let dateLabel = UILabel()
        dateLabel.attributedText = makeStyledDateText()
        dateLabel.numberOfLines = 1
        dateLabel.sizeToFit()
        
        let leftItem = UIBarButtonItem(customView: dateLabel)
        navigationItem.leftBarButtonItem = leftItem
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backButton.tintColor = UIColor.label
        self.navigationItem.backBarButtonItem = backButton
        
    }
    
    // 네비게이션에 표기될 텍스트 별 설정, 달리 설정하는 메서드
    private func makeStyledDateText() -> NSAttributedString {
        let todayText = NSLocalizedString("today", comment: "Prefix for today`s date")
        let dateText = getFormattedDate() // 예: "7월 11일"
        
        let attributedString = NSMutableAttributedString()
        
        // "오늘, "
        let todayAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Ownglyph_daelong-Rg", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .bold),
            .foregroundColor: UIColor.label
        ]
        attributedString.append(NSAttributedString(string: todayText, attributes: todayAttributes))
        
        // "7월 11일"
        let dateAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Ownglyph_daelong-Rg", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold),
            .foregroundColor: UIColor.secondaryLabel
        ]
        attributedString.append(NSAttributedString(string: dateText, attributes: dateAttributes))
        
        return attributedString
    }
    
    // 오늘 날짜를 String 타입으로 변환해주는 메서드
    private func getFormattedDate() -> String {
        
        let formatter = DateFormatter()
        //formatter.locale = Locale(identifier: "ko_KR")
        let locale = Locale.current
        formatter.locale = locale
        
        if locale.language.languageCode?.identifier == "ko" {
            formatter.dateFormat = "yyyy년 M월 d일"
        } else {
            
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
        }
        
        return formatter.string(from: Date())
    }
}


// MARK: - Enum
enum MainCollectionViewSection: Int, CaseIterable {
    case summary
    case breakdown
    
    var title: String {
        switch self {
        case .summary: return "이번달 내역"
        case .breakdown: return "최근 내역"
        }
    }
}
