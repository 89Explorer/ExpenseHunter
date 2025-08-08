//
//  HomeViewController.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/15/25.
//

import UIKit
import Combine


@MainActor
class HomeViewController: UIViewController {
    
    
    // MARK: - Variable
    private let transactionViewModel = TransactionViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let now = Date()
    
    
    // MARK: - UI Component
    private var expenseTableview: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    private var floatingButton: UIButton = UIButton(type: .custom)
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        configureUI()
        //        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        transactionViewModel.readAllTransactions()
        transactionViewModel.setAllTransactions()
        transactionViewModel.checkAndGenerateRepeatedTransactionsIfNeeded()
        bindViewModel()
        configureNavigation()
    }
    
    
    // MARK: - Function
    private func bindViewModel() {
        transactionViewModel.$transactions
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                
                guard let self else { return }
                
                self.expenseTableview.reloadData()
                
            }
            .store(in: &cancellables)
    }
    
    
    private func configureUI() {
        expenseTableview.showsVerticalScrollIndicator = false
        expenseTableview.backgroundColor = .clear
        
        expenseTableview.rowHeight =  UITableView.automaticDimension
        expenseTableview.estimatedRowHeight = 150
        expenseTableview.separatorStyle = .none
        
        expenseTableview.delegate = self
        expenseTableview.dataSource = self
        
        expenseTableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        expenseTableview.register(HomeExpenseCell.self, forCellReuseIdentifier: HomeExpenseCell.reuseIdentifier)
        expenseTableview.register(HomeChartCell.self, forCellReuseIdentifier: HomeChartCell.reuseIdentifier)
        expenseTableview.register(HomeTodayStatusCell.self, forCellReuseIdentifier: HomeTodayStatusCell.reuseIdentifier)
        
        let config = UIImage.SymbolConfiguration(pointSize: 28)
        let plusImage = UIImage(systemName: "plus", withConfiguration: config)
        floatingButton.setImage(plusImage, for: .normal)
        floatingButton.tintColor = .label
        floatingButton.backgroundColor = .systemBlue
        floatingButton.layer.cornerRadius = 28
        floatingButton.layer.shadowOpacity = 0.3
        floatingButton.layer.shadowRadius = 8
        floatingButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        view.addSubview(expenseTableview)
        view.addSubview(floatingButton)
        
        expenseTableview.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            expenseTableview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            expenseTableview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            expenseTableview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            expenseTableview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            floatingButton.widthAnchor.constraint(equalToConstant: 56),
            floatingButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    
    // MARK - Action Method
    @objc private func moreButtonTapped(_ sender: UIButton) {
        guard let section = HomeSection(rawValue: sender.tag) else { return }
        print("더보기 버튼 탭됨: \(section)")
        switch section {
        case .income:
            let chartVC = DetailChartViewController(type: .income)
            navigationController?.pushViewController(chartVC, animated: true)
        case .expense:
            let chartVC = DetailChartViewController(type: .expense)
            navigationController?.pushViewController(chartVC, animated: true)
        case .chart:
            let calendarVC = DetailCalendarViewController()
            navigationController?.pushViewController(calendarVC, animated: true)
        default:
            let chartVC = DetailChartViewController(type: .expense)
            navigationController?.pushViewController(chartVC, animated: true)
        }
        
        // 예: delegate를 통해 전달하거나, 화면 전환 등
    }
    
    @objc private func addButtonTapped(_ sender: UIButton) {
        print("글쓰기 버튼 눌림")
        let addTransactionVC = AddTransactionViewController(mode: .create)
        navigationController?.pushViewController(addTransactionVC, animated: true)
    }
}


// MARK: - Extension: 날짜 설정 메서드
extension HomeViewController {
    
    // 네비게이션 바 부분에 날짜를 넣는 메서드
    private func configureNavigation() {
        
        // 네비게이션 배경색 설정
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.secondarySystemBackground
        //appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        //appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        
        let dateLabel = UILabel()
        dateLabel.attributedText = makeStyledDateText()
        dateLabel.numberOfLines = 1
        dateLabel.sizeToFit()
        
        let leftItem = UIBarButtonItem(customView: dateLabel)
        navigationItem.leftBarButtonItem = leftItem
        
//        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
//        let customBackImage = UIImage(systemName: "chevron.backward", withConfiguration: config)
        //let backBarButtonItem = UIBarButtonItem(title: "", image: customBackImage, target: self, action: nil)
        
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
            .font: UIFont(name: "OTSBAggroB", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .bold),
            .foregroundColor: UIColor.label
        ]
        attributedString.append(NSAttributedString(string: todayText, attributes: todayAttributes))
        
        // "7월 11일"
        let dateAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "OTSBAggroL", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold),
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


// MARK: - Extension: 테이블뷰 설정
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return HomeSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = HomeSection(rawValue: section) else { return 1 }
        
        switch section {
            
        case .today:
            
            let count = transactionViewModel.todayTransactions.count
            return count
            
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let section = HomeSection(rawValue: section) else { return nil }
        
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let label = UILabel()
        label.text = section.title
        label.font = UIFont(name: "OTSBAggroB", size: 20)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
        ])
        
        switch section {
            
        case .income, .expense, .chart:
            
            let moreButton = UIButton(configuration: {
                var config = UIButton.Configuration.filled()
                config.title = NSLocalizedString("see_more", comment: "Button title for 'See more' action")
                config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8) // padding
                config.baseBackgroundColor = .systemBackground
                config.baseForegroundColor = .label
                config.cornerStyle = .capsule
                config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                    var outgoing = incoming
                    outgoing.font = UIFont(name: "OTSBAggroL", size: 12)
                    return outgoing
                }
                return config
            }())
            moreButton.translatesAutoresizingMaskIntoConstraints = false
            
            // 버튼 액션은 필요 시 Target-Action 또는 delegate로 전달
            moreButton.tag = section.rawValue
            moreButton.addTarget(self, action: #selector(moreButtonTapped(_:)), for: .touchUpInside)
            
            headerView.addSubview(moreButton)
            
            NSLayoutConstraint.activate([
                moreButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
                moreButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
            ])
            
        case .today:
            break
        }
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = HomeSection(rawValue: indexPath.section) else { return 0 }
        
        switch section {
        case .chart:
            return 300
        case .today:
            return 68
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = HomeSection(rawValue: indexPath.section) else { fatalError("Invalid section") }
        
        switch section {
            
        case .income, .expense:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeExpenseCell.reuseIdentifier, for: indexPath) as? HomeExpenseCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            let amount = section == .income ? transactionViewModel.totalIncomeThisMonth : transactionViewModel.totalExpenseThisMonth
            let type: TransactionType = section == .income ? .income : .expense
            
            //let title = section == .income ? "이번달, 누적 수입" : "이번달, 누적 지출"
            
            let title = section == .income
            ? NSLocalizedString("income_summary", comment: "This month's total income")
            : NSLocalizedString("expense_summary", comment: "This month's total expense")
            
            cell.configure(with: title, amount: amount, type: type)
            
            return cell
            
        case .today:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTodayStatusCell.reuseIdentifier, for: indexPath) as? HomeTodayStatusCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            let item = transactionViewModel.todayTransactions[indexPath.row]
            cell.configure(with: item)
            
            return cell
            
        case .chart:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeChartCell.reuseIdentifier, for: indexPath) as? HomeChartCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            let weeklyData = transactionViewModel.weeklySummaryData
            cell.configureChart(with: weeklyData)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = HomeSection(rawValue: indexPath.section) else {
            fatalError("Invalid section")
        }
        
        switch section {
        case .today:
            let id = transactionViewModel.todayTransactions[indexPath.row].id
            let editVC = AddTransactionViewController(mode: .edit(id: id))
            navigationController?.pushViewController(editVC, animated: true)
        default:
            break
        }
    }
}


// MARK: - Enum: 홈 테이블 섹션 관리
enum HomeSection: Int, CaseIterable {
    case income
    case expense
    case today
    case chart
    
    var title: String {
        switch self {
        case .income:
            return NSLocalizedString("section_income", comment: "Title for income section")
        case .expense:
            return NSLocalizedString("section_expense", comment: "Title for expense section")
        case .chart:
            return NSLocalizedString("section_chart", comment: "Title for chart section")
        case .today:
            return NSLocalizedString("section_today", comment: "Title for today section")
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .expense: return UIImage(systemName: "minus.circle")
        case .income: return UIImage(systemName: "plus.circle")
        case .chart: return UIImage(systemName: "chart.bar")
        case .today: return UIImage(systemName: "gear")
        }
    }
}

