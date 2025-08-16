//
//  MoreChartViewController.swift
//  ExpenseHunter
//
//  Created by 권정근 on 8/11/25.
//

import UIKit
import Combine

class MoreChartViewController: UIViewController {
    
    
    // MARK: - Variable
    private var transactionType: TransactionType
    private var transactionViewModel = TransactionViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    private var selectedMonth: Int = Calendar.current.component(.month, from: Date()) {
        didSet {
            transactionViewModel.fetchWeeklyTotals(month: selectedMonth, type: transactionType)
        }
    }
    
    private var months: [MonthItem] = Calendar.current.shortMonthSymbols.enumerated().map {
        MonthItem(shortName: $0.element, number: $0.offset + 1)
    }
    private var isInitialScrollDone: Bool = false
    
    
    // MARK: - UI Component
    private var collectionView: UICollectionView!
    
    
    // MARK: - init
    init(type: TransactionType) {
        self.transactionType = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigaiton()
        configureUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        transactionViewModel.readAllTransactions()
        //transactionViewModel.setAllTransactions()
        bindViewModel()
        
        // 최초 진입시 데이터 불러오기
        transactionViewModel.fetchWeeklyTotals(
            month: selectedMonth,
            type: transactionType
        )

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isInitialScrollDone {
            if let index = months.firstIndex(where: { $0.number == selectedMonth }) {
                let indexPath = IndexPath(item: index, section: MoreChart.monthly.rawValue)
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            }
            isInitialScrollDone = true
        }
    }
    
    
    // MARK: - Function
    private func bindViewModel() {
        transactionViewModel.$weeklyTotals
            .receive(on: DispatchQueue.main)
            .sink { [weak self] totals in
                print("주차별 데이터 업데이트: ", totals)
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    
    private func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        
        let layout = UICollectionViewCompositionalLayout { [weak self] section, _ in
            guard let sectionType = MoreChart(rawValue: section) else { return nil }
            switch sectionType {
            case .monthly:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(60), heightDimension: .absolute(52))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 8
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
                return section
            default:
                // 다른 섹션 레이아웃 기본 예시
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
                return NSCollectionLayoutSection(group: group)
            }
        }
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(MoreMonthCell.self, forCellWithReuseIdentifier: MoreMonthCell.reuseIdentifier)
        collectionView.register(MoreChartCell.self, forCellWithReuseIdentifier: MoreChartCell.reuseIdentifier)
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
}


// MARK: - Extension
extension MoreChartViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return MoreChart.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = MoreChart(rawValue: section) else { return 1 }
        
        switch section {
        case .monthly:
            return months.count
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = MoreChart(rawValue: indexPath.section) else { fatalError("Invalid section") }
        
        switch section {
        case .monthly:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoreMonthCell.reuseIdentifier, for: indexPath) as! MoreMonthCell
            let item = months[indexPath.item]
            cell.configure(with: item, isSelected: item.number == selectedMonth)
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell.backgroundColor = .systemGray5
            return cell
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let section = MoreChart(rawValue: indexPath.section), section == .monthly else { return }
//        selectedMonth = months[indexPath.item].number
//        collectionView.reloadSections(IndexSet(integer: MoreChart.monthly.rawValue))
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = MoreChart(rawValue: indexPath.section), section == .monthly else { return }
        
        let previousIndex = months.firstIndex { $0.number == selectedMonth }
        selectedMonth = months[indexPath.item].number
        
        var indexPathsToReload: [IndexPath] = [indexPath]
        
        if let previousIndex = previousIndex {
            indexPathsToReload.append(IndexPath(item: previousIndex, section: MoreChart.monthly.rawValue))
        }
        
        collectionView.reloadItems(at: indexPathsToReload)
        
        // 선택된 셀 중앙으로 스크롤 (선택감 강화)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

}


// MARK: - Extension
extension MoreChartViewController {
    
    /// 네비게이션 설정 메서드
    private func configureNavigaiton() {
        let titleLabel: UILabel = UILabel()
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.text = NSLocalizedString("Monthly_Breakdown", comment: "Title for Monthly Breakdown")
        titleLabel.font =  UIFont(name: "Ownglyph_daelong-Rg", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
        
        self.navigationItem.titleView = titleLabel
    }
}


// MARK: - Enum
enum MoreChart: Int, CaseIterable {
    case monthly
    case income
    case expense
    
    var title: String {
        switch self {
        case .monthly: return "월별 현황"
        case .income: return "소득"
        case .expense: return "지출"
        }
    }
}
