//
//  AddTransactionViewController.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/16/25.
//

import UIKit

class AddTransactionViewController: UIViewController {
    
    
    // MARK: - Variable
    private let addSection: [String] = ["구분", "날짜", "금액", "분류", "자산출처", "내용"]
    private var selectedTransactionType: TransactionType = .expense {
        didSet {
            // 수입 / 지출 버튼이 선택되면 자동으로 date 섹션이 선택된 걸로 간주
            selectedIndexPath = IndexPath(row: 0, section: AddSection.date.rawValue)
            updateTitle()
            self.addTableView.reloadData()
        }
    }
    private var selectedIndexPath: IndexPath?
    
    // 선택된 날짜를 저장하기 위한 변수
    private var selectedDate: Date?
    private var selectedAmount: Int?
    
    
    // MARK: - UI Component
    private let addTableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    private let saveButton: UIButton = UIButton(type: .custom)
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        configureUI()
    }
    
    
    // MARK: - Function
    private func configureUI() {
        
        self.title = "지출 입력"
        
        addTableView.showsVerticalScrollIndicator = false
        addTableView.layer.cornerRadius = 12
        addTableView.backgroundColor = .systemBackground
        addTableView.separatorStyle = .none
        addTableView.rowHeight = UITableView.automaticDimension
        addTableView.estimatedRowHeight = 100
        
        addTableView.dataSource = self
        addTableView.delegate = self
        
        addTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        addTableView.register(AddTypeCell.self, forCellReuseIdentifier: AddTypeCell.reuseIdentifier)
        addTableView.register(AddCustomCell.self, forCellReuseIdentifier: AddCustomCell.reuseIdentifier)
        
        saveButton.setTitle("저장하기", for: .normal)
        saveButton.setTitleColor(.label, for: .normal)
        saveButton.layer.cornerRadius = 16
        saveButton.backgroundColor = .systemBlue
        
        view.addSubview(addTableView)
        view.addSubview(saveButton)
        addTableView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            addTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            addTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            addTableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -8),
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            saveButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    // AddType에서 선택한 버튼에 따라 제목 설정
    func updateTitle() {
        switch selectedTransactionType {
        case .income:
            self.title = "수입 입력"
        case .expense:
            self.title = "지출 입력"
        default:
            self.title = "영수증 작성"
        }
    }
}


// MARK: - Extension: 테이블뷰의 설정
extension AddTransactionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return AddSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = AddSection(rawValue: indexPath.section) else { fatalError("Invalid section") }
        
        switch section {
        case .addType:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddTypeCell.reuseIdentifier, for: indexPath) as? AddTypeCell else { return UITableViewCell() }
            cell.delegate = self
            cell.selectionStyle = .none
            cell.configure(selectedType: selectedTransactionType)
            return cell
            
        case .date, .amount, .category:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddCustomCell.reuseIdentifier, for: indexPath) as? AddCustomCell else { return UITableViewCell() }
            cell.configure(title: section.title)
            cell.selectionStyle = .none
            cell.delegate = self
            
            let isSelected = (indexPath == selectedIndexPath)
            cell.updateSeparatorColor(
                isSelected: isSelected,
                transactionType: selectedTransactionType
            )
            
            // 셀의 valueLabel 탭 제스처 연결
            cell.onValueLabelTapped = { [weak self] in
                self?.selectedIndexPath = indexPath
                self?.addTableView.reloadData()
                // 여기에 calendarView 또는 numberPad 띄우는 로직도 추가
            }
            
            if section == .date {
                if let selectedDate = selectedDate {
                    cell.updateDateValue(with: selectedDate)
                }
            } else if section == .amount {
                if let selectedAmount = selectedAmount {
                    cell.updateAmountValue(with: selectedAmount)
                }
            }
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "TEST"
            return cell
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = AddSection(rawValue: indexPath.section) else { fatalError("Invalid section") }
        switch section {
        case .addType, .date, .amount, .category:
            return 48
        default:
            return UITableView.automaticDimension
        }
    }
}


// MARK: - Extension: AddType에서 선택한 버튼에 따라
extension AddTransactionViewController: AddTypeCellDelegate {
    func didSelectTransactionType(_ type: TransactionType) {
        selectedTransactionType = type
        // 만약 .category 섹션도 갱신하려면 여기에 reload 추가
        // tableView.reloadSections([AddSection.category.rawValue], with: .automatic)
    }
}


// MARK: - Extension: 각 셀의 valueLabel을 눌렀을 떄 동작하는 기능 구현 목적
extension AddTransactionViewController: AddCustomCellDelegate {
    func valueLabelTapped(in cell: AddCustomCell) {
        guard let indexPath = addTableView.indexPath(for: cell),
              let section = AddSection(rawValue: indexPath.section) else { return }
        
        selectedIndexPath = indexPath
        
        switch section {
        case .date:
            print("날짜 valueLabel 눌림")
            presentCalendarPicker()
        case .amount:
            print("금액 valueLabel 눌림")
            presentAmountCalculator()
        case .category:
            print("분류 valueLabel 눌림")
        default:
            print("기타 valueLabel 눌림")
        }
        
        // ✅ 선택 효과를 위해 셀 리로드
        self.addTableView.reloadRows(at: [indexPath], with: .none)
        
    }
    
    private func presentCalendarPicker() {
        let dateVC = AddDateViewController()
        dateVC.modalPresentationStyle = .pageSheet
        
        dateVC.onDateSelected = { [weak self] selectedDate in
            print("🔁 Date picked: \(selectedDate)")
            self?.selectedDate = selectedDate
            self?.addTableView.reloadRows(at: [IndexPath(row: 0, section: AddSection.date.rawValue)], with: .none)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                guard let self = self else { return }
                let nextIndexPath = IndexPath(row: 0, section: AddSection.date.rawValue)
                if let cell = self.addTableView.cellForRow(at: nextIndexPath) as? AddCustomCell {
                    cell.updateDateValue(with: selectedDate)
                }
            }
        }
        
        if let sheet = dateVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        present(dateVC, animated: true)
    }
    
    private func presentAmountCalculator() {
        let amountVC = AddAmountViewController()
        amountVC.modalPresentationStyle = .pageSheet
        
        amountVC.onAmountSelected = { [weak self] amount in
            guard let self = self else { return }
            self.selectedAmount = amount
            
            // 금액 셀 업데이트
            self.addTableView.reloadRows(
                at: [IndexPath(row: 0, section: AddSection.amount.rawValue)],
                with: .none
            )
            
            // 다음 섹션으로 이동
            let nextIndexPath = IndexPath(row: 0, section: AddSection.category.rawValue)
            self.addTableView.scrollToRow(at: nextIndexPath, at: .middle, animated: true)
        }

        if let sheet = amountVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }

        present(amountVC, animated: true)
    }

}


// MARK: - Enum: 작성 테이블 섹션 관리
enum AddSection: Int, CaseIterable {
    case addType
    case date
    case amount
    case category
    case memo
    
    var title: String {
        switch self {
        case .date: return "날짜"
        case .amount: return "금액"
        case .category: return "분류"
        default: return ""
        }
    }
}

