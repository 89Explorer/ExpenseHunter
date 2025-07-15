//
//  ExpenseViewModel.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/15/25.
//

import UIKit
import Combine


class ExpenseViewModel {
    
    
    // MARK: - Published Properties
    @Published var expenses: [ExpenseModel] = []
    
    
    // MARK: - Init
    init() {
        loadDummyData()
    }
    
    
    // MARK: - Function
    func loadDummyData() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        expenses = [
            ExpenseModel(
                transaction: .expense,
                category: "식비",
                amount: 12000,
                image: nil,
                date: formatter.date(from: "2025-07-01")!
            ),
            ExpenseModel(
                transaction: .expense,
                category: "교통비",
                amount: 3500,
                image: nil,
                date: formatter.date(from: "2025-07-03")!
            ),
            ExpenseModel(
                transaction: .income,
                category: "월급",
                amount: 3000000,
                image: nil,
                date: formatter.date(from: "2025-07-01")!
            ),
            ExpenseModel(
                transaction: .income,
                category: "보너스",
                amount: 500000,
                image: nil,
                date: formatter.date(from: "2025-07-10")!
            ),
            ExpenseModel(
                transaction: .expense,
                category: "문화생활",
                amount: 25000,
                image: nil,
                date: formatter.date(from: "2025-07-08")!
            )
        ]
    }
    
    func filteredExpenses(for type: TransactionType) -> [ExpenseModel] {
        expenses.filter { $0.transaction == type }
    }
    
    func totalAmount(for type: TransactionType) -> Int {
        filteredExpenses(for: type).reduce(0) { $0 + $1.amount }
    }
}
