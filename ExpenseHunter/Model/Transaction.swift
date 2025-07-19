//
//  Transaction.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/11/25.
//

import Foundation
import UIKit


// 가계부 모델 정의
enum TransactionType: String {
    case income
    case expense

    var categoryOptions: [String] {
        switch self {
        case .income:
            return ["월급", "성과금", "용돈", "보너스", "금융소득"]
        case .expense:
            return [
                "식비", "교통비", "문화생활", "생활품", "의류", "보험", "미용",
                "의료/건강", "교육", "통신비", "회비", "세금", "경조사", "저축",
                "가전", "공과금", "카드대금", "기타"
            ]
        }
    }

    var categoryImageMap: [String: String] {
        switch self {
        case .income:
            return [
                "월급": "dollarsign.circle.fill",    // 💰
                "성과금": "gift.fill",               // 🎁
                "용돈": "hands.sparkles.fill",       // 🤲
                "보너스": "gift.fill",               // 🎁 (중복)
                "금융소득": "chart.line.uptrend.xyaxis" // 📈
            ]
        case .expense:
            return [
                "식비": "fork.knife",                  // 🍽
                "교통비": "car.fill",                  // 🚗
                "문화생활": "music.note.house.fill",     // 🎵🏠
                "생활품": "cart.fill",                 // 🛒
                "의류": "tshirt.fill",                 // 👕
                "보험": "shield.lefthalf.fill",        // 🛡
                "미용": "scissors",                   // ✂️
                "의료/건강": "cross.case.fill",        // 🩺
                "교육": "book.fill",                  // 📘
                "통신비": "antenna.radiowaves.left.and.right", // 📡
                "회비": "person.3.fill",               // 👥
                "세금": "doc.plaintext.fill",         // 📄
                "경조사": "gift.fill",                // 🎁 (중복 사용)
                "저축": "banknote.fill",              // 💵
                "가전": "tv.fill",                    // 📺
                "공과금": "bolt.fill",                 // ⚡️
                "카드대금": "creditcard.fill",         // 💳
                "기타": "ellipsis.circle.fill"         // ⋯
            ]
        }
    }
    
    /*
     사용 예시
     let type: TransactionType = .income
     let category: String = "월급"

     if let systemName = type.categoryImageMap[category] {
         let image = UIImage(systemName: systemName)
         imageView.image = image
     }
     */
}

// 가계부 데이터 모델
class ExpenseModel {
    let id: UUID
    let transaction: TransactionType
    let category: String   // ✅ 사용자는 context menu에서 선택하게 될 것
    let amount: Int
    let image: UIImage?
    let date: Date
    let memo: String

    init(id: UUID = UUID(),
         transaction: TransactionType,
         category: String,
         amount: Int,
         image: UIImage? = nil,
         date: Date = Date(),
         memo: String
    ) {

        self.id = id
        self.transaction = transaction
        self.category = category
        self.amount = amount
        self.image = image
        self.date = date
        self.memo = memo
    }
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

private var incomeOptions = ["월급", "성과금", "용돈", "보너스", "금융소득"]
private var expenseOptions = ["식비", "교통비", "문화생활", "생활품", "의류", "보험", "미용", "의료/건강", "교육", "통신비", "회비", "세금", "경조사", "저축", "가전", "공과금", "카드대금", "기타"]
