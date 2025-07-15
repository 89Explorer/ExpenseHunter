//
//  HomeViewController.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/15/25.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    
    // MARK: - UI Component
    private var expenseTableview: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    private var floatingButton: UIButton = UIButton(type: .custom)
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        configureNavigation()
        configureUI()
    }
    
    
    // MARK: - Function
    private func configureUI() {
        expenseTableview.showsVerticalScrollIndicator = false
        expenseTableview.backgroundColor = .clear
        
        expenseTableview.rowHeight =  UITableView.automaticDimension
        expenseTableview.estimatedRowHeight = 150
        
        expenseTableview.delegate = self
        expenseTableview.dataSource = self
        
        expenseTableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        expenseTableview.register(HomeExpenseCell.self, forCellReuseIdentifier: HomeExpenseCell.reuseIdentifier)
        expenseTableview.register(HomeChartCell.self, forCellReuseIdentifier: HomeChartCell.reuseIdentifier)
        expenseTableview.register(HomeTodayStatusCell.self, forCellReuseIdentifier: HomeTodayStatusCell.reuseIdentifier)
        
        floatingButton.setImage(UIImage(systemName: "plus"), for: .normal)
        floatingButton.tintColor = .label
        floatingButton.backgroundColor = .systemOrange
        floatingButton.layer.cornerRadius = 28
        floatingButton.layer.shadowOpacity = 0.3
        floatingButton.layer.shadowRadius = 8
        
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
    
    @objc private func moreButtonTapped(_ sender: UIButton) {
        guard let section = HomeSection(rawValue: sender.tag) else { return }
        print("더보기 버튼 탭됨: \(section)")
        
        // 예: delegate를 통해 전달하거나, 화면 전환 등
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
    }
    
    // 네비게이션에 표기될 텍스트 별 설정, 달리 설정하는 메서드
    private func makeStyledDateText() -> NSAttributedString {
        let todayText = "오늘 "
        let dateText = getFormattedDate() // 예: "7월 11일"
        
        let attributedString = NSMutableAttributedString()
        
        // "오늘, "
        let todayAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "OTSBAggroB", size: 24),
            .foregroundColor: UIColor.label
        ]
        attributedString.append(NSAttributedString(string: todayText, attributes: todayAttributes))
        
        // "7월 11일"
        let dateAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "OTSBAggroL", size: 20),
            .foregroundColor: UIColor.secondaryLabel
        ]
        attributedString.append(NSAttributedString(string: dateText, attributes: dateAttributes))
        
        return attributedString
    }
    
    // 오늘 날짜를 String 타입으로 변환해주는 메서드
    private func getFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
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
            return 5
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
        
        let moreButton = UIButton(type: .system)
        moreButton.setTitle("더보기", for: .normal)
        moreButton.setTitleColor(.systemBlue, for: .normal)
        moreButton.titleLabel?.font = UIFont(name: "OTSLAggroB", size: 12)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 버튼 액션은 필요 시 Target-Action 또는 delegate로 전달
        moreButton.tag = section.rawValue
        moreButton.addTarget(self, action: #selector(moreButtonTapped(_:)), for: .touchUpInside)

        // 서브뷰 추가
        headerView.addSubview(label)
        headerView.addSubview(moreButton)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),

            moreButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            moreButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
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
        case .income:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeExpenseCell.reuseIdentifier, for: indexPath) as? HomeExpenseCell else { return UITableViewCell() }
            cell.configure(with: "이번달, 누적 수입", amount: 3000000, type: .income)
            return cell
        case .expense:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeExpenseCell.reuseIdentifier, for: indexPath) as? HomeExpenseCell else { return UITableViewCell() }
            
            cell.configure(with: "이번달, 누적 지출", amount: 300000, type: .expense)
            return cell
        case .today:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTodayStatusCell.reuseIdentifier, for: indexPath) as? HomeTodayStatusCell else { return UITableViewCell() }
            return cell 
        case .chart:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeChartCell.reuseIdentifier, for: indexPath) as? HomeChartCell else { return UITableViewCell() }
            return cell 
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeExpenseCell.reuseIdentifier, for: indexPath) as? HomeExpenseCell else { return UITableViewCell() }
            return cell
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
        case .income: return "📥 수입"
        case .expense: return "📤 지출"
        case .chart: return "📊 주간 수입/지출 현황"
        case .today: return "📝 오늘 수입/지출 현황"
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
