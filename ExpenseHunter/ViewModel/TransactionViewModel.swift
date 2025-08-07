//
//  TransactionViewModel.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/19/25.
//

import Foundation
import UIKit
import Combine


final class TransactionViewModel {
    
    
    // MARK: - Published Properties
    @Published var transaction: ExpenseModel?
    @Published var transactions: [ExpenseModel] = []
    @Published var errorMessage: String?
    
    @Published private(set) var todayTransactions: [ExpenseModel] = []
    @Published private(set) var totalIncomeThisMonth: Int = 0
    @Published private(set) var totalExpenseThisMonth: Int = 0
    @Published private(set) var weeklySummaryData: [(day: String, income: Double, expense: Double)] = []
    
    var currentCategories: [String] {
        transaction?.transaction.categoryOptions ?? []
    }
    
    var currentCategoryIcons: [String: String] {
        transaction?.transaction.categoryImageMap ?? [:]
    }
    
    private var cancellables: Set<AnyCancellable> = []
    private let transactionManager = TransactionCoreDataManager.shared
    
    let mode: AddTransactionMode?
    
    
    // MARK: - Init
    init(mode: AddTransactionMode? = nil) {
        self.mode = mode
        
        if let mode = mode {
            switch mode {
            case .create:
                self.transaction = ExpenseModel(
                    id: UUID(),
                    transaction: .expense,
                    category: "",
                    amount: 0,
                    image: nil,
                    date: Date(),
                    memo: ""
                )
            case .edit(let id):
                readByIDTransaction(by: id)
            }
        } else {
            // 기본 초기화 (예: HomeViewController 등에서 사용)
            self.transaction = nil
        }
    }
    
    
    // MARK: - Function
    
    // 각 Published Properties에 값을 전달
    func setAllTransactions() {
        todayTransactions = filteredTransactions(in: Date(), granularity: .day)
        totalIncomeThisMonth = totalAmount(type: .income, in: Date(), granularity: .month)
        totalExpenseThisMonth = totalAmount(type: .expense, in: Date(), granularity: .month)
        weeklySummaryData = weeklySummary(in: Date())
    }
    
    
    // Create
    func createTransaction() {
        guard let transaction = transaction else {
            errorMessage = "Transaction no data"
            return
        }
        
        transactionManager.createTransaction(transaction)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] savedTransaction in
                self?.transactions.append(savedTransaction)
                self?.transaction = savedTransaction
            })
            .store(in: &cancellables)
    }
    
    //    func createTransaction(_ transaction: ExpenseModel, image: UIImage) {
    //        transactionManager.createTransaction(transaction, image: image)
    //            .sink(receiveCompletion: { completion in
    //                switch completion {
    //                case .finished:
    //                    break
    //                case .failure(let error):
    //                    self.errorMessage = error.localizedDescription
    //                }
    //            }, receiveValue: { [weak self] savedTransaction in
    //                self?.transactions.append(savedTransaction)
    //                self?.transaction = savedTransaction
    //            })
    //            .store(in: &cancellables)
    //    }
    
    
    // ReadAll
    func readAllTransactions() {
        transactionManager.readAllTransaction()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                
            }, receiveValue: { [weak self] savedTransaction in
                self?.transactions = savedTransaction
            })
            .store(in: &cancellables)
    }
    
    
    // Read By ID
    func readByIDTransaction(by id: UUID) {
        transactionManager.readTransactionByID(by: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
                
            }, receiveValue: { [weak self] readedTransaction in
                self?.transaction = readedTransaction
            })
            .store(in: &cancellables)
    }
    
    // 업데이트 메서드
    func updateTransaction() {
        guard let transaction = transaction else {
            errorMessage = "Transaction no data"
            return
        }
        
        transactionManager.updateTransaction(transaction)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] updated in
                self?.transaction = updated
            })
            .store(in: &cancellables)
    }
    
    //    func updateTransaction(_ updatedTransaction: ExpenseModel) {
    //        transactionManager.updateTransaction(updatedTransaction)
    //            .receive(on: DispatchQueue.main)
    //            .sink(receiveCompletion: { [weak self] completion in
    //                switch completion {
    //                case .finished:
    //                    break
    //                case .failure(let error):
    //                    self?.errorMessage = error.localizedDescription
    //                }
    //            }, receiveValue: { [weak self] updated in
    //                self?.transaction = updated
    //            })
    //            .store(in: &cancellables)
    //    }
    
    
    // Delete
    func deleteTransaction(by id: UUID) {
        transactionManager.deleteTransaction(id: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = "삭제 실패: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] success in
                guard let self = self else { return }
                if success {
                    print("✅ ViewModel: CoreData 삭제 성공")
                    
                    // 배열에서 삭제
                    self.transactions.removeAll { $0.id == id }
                    
                    // 현재 선택된 트랜잭션도 초기화
                    if self.transaction?.id == id {
                        self.transaction = nil
                    }
                    
                } else {
                    self.errorMessage = "삭제 실패: 알 수 없는 이유"
                }
            })
            .store(in: &cancellables)
    }
    
    
    // 특정 타입, 날짜로 필터된 배열을 구하는 메서드
    //    func filteredTransactions(
    //        type: TransactionType,
    //        in date: Date,
    //        granularity: Calendar.Component = .month
    //    ) -> [ExpenseModel] {
    //        let calendar = Calendar.current
    //
    //        return transactions.filter { transaction in
    //            guard transaction.transaction == type else { return false }
    //            return calendar.isDate(transaction.date, equalTo: date, toGranularity: granularity)
    //        }
    //    }
    
    
    // 특정 타입, 날짜를 통해 필터된 배열을 구하는 메서드
    func filteredTransactions(
        type: TransactionType? = nil,
        in date: Date,
        granularity: Calendar.Component = .month
    ) -> [ExpenseModel] {
        let calendar = Calendar.current
        
        let filtered = transactions.filter { transaction in
            let matchesType = type == nil || transaction.transaction == type!
            let matchesDate = calendar.isDate(transaction.date, equalTo: date, toGranularity: granularity)
            return matchesType && matchesDate
        }
        
        //return filtered.sorted { $0.date > $1.date }
        return filtered
    }
    
    
    // 주어진 날자 기준으로 주간 데이터 반환 (월 ~ 일)
    func weeklySummary(in baseDate: Date) -> [(day: String, income: Double, expense: Double)] {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: baseDate))!
        
        var result: [(String, Double, Double)] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        
        for i in 0..<7 {
            guard let day = calendar.date(byAdding: .day, value: i, to: startOfWeek) else { continue }
            
            let incomeForDay = transactions.filter {
                $0.transaction == .income && calendar.isDate($0.date, inSameDayAs: day)
            }.map { Double($0.amount) }.reduce(0, +)
            
            let expenseForDay = transactions.filter {
                $0.transaction == .expense && calendar.isDate($0.date, inSameDayAs: day)
            }.map { Double($0.amount) }.reduce(0, +)
            
            result.append((formatter.string(from: day), incomeForDay, expenseForDay))
        }
        return result
    }
    
    
    // 누적 금액 계산
    func totalAmount(
        type: TransactionType,
        in date: Date,
        granularity: Calendar.Component = .month) -> Int {
            let filtered = filteredTransactions(type: type, in: date, granularity: granularity)
            return filtered.reduce(0) { $0 + $1.amount}
        }
    
    
    // 유효성 검사 메서드
    func validateTransaction() -> Bool {
        guard let transaction = transaction else {
            errorMessage = "내역 정보가 없습니다."
            return false
        }
        
        if transaction.category.isEmpty  {
            errorMessage = "분류를 선택해주세요"
            return false
        }
        
        return true
    }
    
    
    // 반복 주기에 따라 날짜 계산
//    private func nextCycleDate(from date: Date, cycle: RepeatCycle) -> Date {
//        var component: Calendar.Component
//        
//        switch cycle {
//        case .daily: component = .day
//        case .weekly: component = .weekOfYear
//        case .monthly: component = .month
//        case .yearly: component = .year
//        case .none: return date
//        }
//        
//        return Calendar.current.date(byAdding: component, value: 1, to: date) ?? date
//    }
    
    // MARK: - 반복 기능 관련 메서드
    // 1. 실행 메서드 (반복 항목만 필터링)
    func checkAndGenerateRepeatedTransactionsIfNeeded() {
        let today = Date()
        let repeatedItems = fetchRepeatableTransactions()
        
        for base in repeatedItems {
            generateUpcomingTransactionsIfNeeded(for: base, until: today)
        }
    }
    
    // 2. 반복 항목 필터링
    private func fetchRepeatableTransactions() -> [ExpenseModel] {
        return transactions.filter { $0.isRepeated ?? false && $0.repeatCycle != nil }
    }
    
    
    // 3. 반복 항목별로 필요한 날짜 확인
    private func generateUpcomingTransactionsIfNeeded(for base: ExpenseModel, until targetDate: Date) {
        guard let cycle = base.repeatCycle else { return }
        
        var nextDate = findNextDate(for: base, cycle: cycle)
        
        while nextDate <= targetDate {
            if shouldGenerateTransaction(for: base, on: nextDate) {
                createRepeatedTransaction(from: base, on: nextDate)
            }
            nextDate = nextCycleDate(from: nextDate, cycle: cycle)
        }
    }
    
    // 4. 최신 반복 날자 구하기
    private func findNextDate(for base: ExpenseModel, cycle: RepeatCycle) -> Date {
        let latest = transactions
            .filter {
                $0.category == base.category &&
                $0.amount == base.amount &&
                $0.transaction == base.transaction &&
                !($0.isRepeated ?? false)
            }
            .map { $0.date }
            .max() ?? base.date

        return nextCycleDate(from: latest, cycle: cycle)
    }
    
    // 5. 생성 여부 판단
    private func shouldGenerateTransaction(for base: ExpenseModel, on date: Date) -> Bool {
        return !transactions.contains {
            $0.date == date &&
            $0.amount == base.amount &&
            $0.transaction == base.transaction &&
            $0.category == base.category &&
            !($0.isRepeated ?? false)
        }
    }
    
    // 6. 복제 생성 및 저장
    private func createRepeatedTransaction(from base: ExpenseModel, on date: Date) {
        let new = ExpenseModel(
            id: UUID(),
            transaction: base.transaction,
            category: base.category,
            amount: base.amount,
            image: nil,
            date: date,
            memo: base.memo ?? "",
            isRepeated: false,
            repeatCycle: .none
        )

        transactionManager.createTransaction(new)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] saved in
                self?.transactions.append(saved)
            })
            .store(in: &cancellables)
    }
    
    // 7. 다음 날짜 계산 메서드
    private func nextCycleDate(from date: Date, cycle: RepeatCycle) -> Date {
        var component: Calendar.Component
        
        switch cycle {
        case .daily: component = .day
        case .weekly: component = .weekOfYear
        case .monthly: component = .month
        case .yearly: component = .year
        case .none: return date
        }
        
        return Calendar.current.date(byAdding: component, value: 1, to: date) ?? date
    }
}

