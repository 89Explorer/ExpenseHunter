//
//  Transaction.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/11/25.
//

import Foundation
import UIKit


// MARK: - Enum 가계부 모델 정의
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

// MARK: - Class 가계부 데이터 모델
class ExpenseModel {
    let id: UUID
    var transaction: TransactionType
    var category: String   // ✅ 사용자는 context menu에서 선택하게 될 것
    var amount: Int
    var image: UIImage?
    var date: Date
    var memo: String?
    
    // 반복 기능 설정
    var isRepeated: Bool?
    var repeatCycle: RepeatCycle?

    init(id: UUID = UUID(),
         transaction: TransactionType,
         category: String,
         amount: Int,
         image: UIImage? = nil,
         date: Date = Date(),
         memo: String,
         isRepeated: Bool = false,
         repeatCycle: RepeatCycle = .none
    ) {

        self.id = id
        self.transaction = transaction
        self.category = category
        self.amount = amount
        self.image = image
        self.date = date
        self.memo = memo
        self.isRepeated = isRepeated
        self.repeatCycle = repeatCycle
        
    }
}


// MARK: - Enum 반복 정의
enum RepeatCycle: String, CaseIterable, Codable {
    case none
    case daily
    case weekly
    case monthly
    case yearly
    
    var title: String {
        switch self {
        case .none: return "반복 없음"
        case .daily: return "매일"
        case .weekly: return "매주"
        case .monthly: return "매달"
        case .yearly: return "매년"
        }
    }
}


// MARK: - Enum 모드 정의
enum AddTransactionMode {
    case create
    case edit(id: UUID)
}
