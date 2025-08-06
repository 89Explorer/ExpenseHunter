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
}

