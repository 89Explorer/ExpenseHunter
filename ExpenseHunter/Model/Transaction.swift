//
//  Transaction.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/11/25.
//

import Foundation
import UIKit


// 가계부 모델 정의
enum TransactionType {
    case income
    case expense
}

struct Transaction {
    let category: TransactionType  // 수입 or 지출
    let type: String                  // 구분 (식비, 월급 등)
    let amount: Int                   // 원 단위
    let image: UIImage?               // 이미지
    let date: Date                    // 날짜 (일주일 내)
}

// 가계뷰의 더미 데이터 
extension Transaction {
    static func dummyData() -> [Transaction] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let calendar = Calendar.current
        let today = Date()
        
        return [
            Transaction(category: .expense, type: "식비", amount: 12000, image: UIImage(systemName: "cart.fill"), date: calendar.date(byAdding: .day, value: -1, to: today)!),
            Transaction(category: .expense, type: "교통비", amount: 3000, image: UIImage(systemName: "bus"), date: calendar.date(byAdding: .day, value: -2, to: today)!),
            Transaction(category: .income, type: "월급", amount: 2500000, image: UIImage(systemName: "banknote"), date: calendar.date(byAdding: .day, value: -3, to: today)!),
            Transaction(category: .expense, type: "문화생활", amount: 15000, image: UIImage(systemName: "film"), date: calendar.date(byAdding: .day, value: -4, to: today)!),
            Transaction(category: .income, type: "용돈", amount: 50000, image: UIImage(systemName: "giftcard"), date: calendar.date(byAdding: .day, value: -5, to: today)!),
            Transaction(category: .expense, type: "생필품", amount: 8700, image: UIImage(systemName: "basket"), date: calendar.date(byAdding: .day, value: -6, to: today)!),
        ]
    }
}
