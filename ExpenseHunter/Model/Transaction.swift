//
//  Transaction.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/11/25.
//

import Foundation
import UIKit


// MARK: - Enum 가계부 모델 정의
//enum TransactionType: String {
//    case income
//    case expense
//
//    var categoryOptions: [String] {
//        switch self {
//        case .income:
//            return ["월급", "성과금", "용돈", "보너스", "금융소득"]
//        case .expense:
//            return [
//                "식비", "교통비", "문화생활", "생활품", "의류", "보험", "미용",
//                "의료/건강", "교육", "통신비", "회비", "세금", "경조사", "저축",
//                "가전", "공과금", "카드대금", "기타"
//            ]
//        }
//    }
//
//    var categoryImageMap: [String: String] {
//        switch self {
//        case .income:
//            return [
//                "월급": "dollarsign.circle.fill",    // 💰
//                "성과금": "gift.fill",               // 🎁
//                "용돈": "hands.sparkles.fill",       // 🤲
//                "보너스": "gift.fill",               // 🎁 (중복)
//                "금융소득": "chart.line.uptrend.xyaxis" // 📈
//            ]
//        case .expense:
//            return [
//                "식비": "fork.knife",                  // 🍽
//                "교통비": "car.fill",                  // 🚗
//                "문화생활": "music.note.house.fill",     // 🎵🏠
//                "생활품": "cart.fill",                 // 🛒
//                "의류": "tshirt.fill",                 // 👕
//                "보험": "shield.lefthalf.fill",        // 🛡
//                "미용": "scissors",                   // ✂️
//                "의료/건강": "cross.case.fill",        // 🩺
//                "교육": "book.fill",                  // 📘
//                "통신비": "antenna.radiowaves.left.and.right", // 📡
//                "회비": "person.3.fill",               // 👥
//                "세금": "doc.plaintext.fill",         // 📄
//                "경조사": "gift.fill",                // 🎁 (중복 사용)
//                "저축": "banknote.fill",              // 💵
//                "가전": "tv.fill",                    // 📺
//                "공과금": "bolt.fill",                 // ⚡️
//                "카드대금": "creditcard.fill",         // 💳
//                "기타": "ellipsis.circle.fill"         // ⋯
//            ]
//        }
//    }
//    
//    /*
//     사용 예시
//     let type: TransactionType = .income
//     let category: String = "월급"
//
//     if let systemName = type.categoryImageMap[category] {
//         let image = UIImage(systemName: systemName)
//         imageView.image = image
//     }
//     */
//}

enum TransactionType: String {
    case income
    case expense

    var categoryOptions: [String] {
        switch self {
        case .income:
            return [
                NSLocalizedString("category_salary", comment: ""),
                NSLocalizedString("category_bonus", comment: ""),
                NSLocalizedString("category_allowance", comment: ""),
                NSLocalizedString("category_side_job", comment: ""),
                NSLocalizedString("category_investment", comment: ""),
                NSLocalizedString("category_financial_income", comment: ""),
                NSLocalizedString("category_incentive", comment: ""),
                NSLocalizedString("category_retirement", comment: ""),
                NSLocalizedString("category_rental_income", comment: ""),
                NSLocalizedString("category_dividend", comment: ""),
                NSLocalizedString("category_repayment", comment: ""),
                NSLocalizedString("category_inheritance", comment: ""),
                NSLocalizedString("category_lottery", comment: ""),
                NSLocalizedString("category_other_income", comment: "")
            ]
        case .expense:
            return [
                NSLocalizedString("category_food", comment: ""),
                NSLocalizedString("category_transport", comment: ""),
                NSLocalizedString("category_entertainment", comment: ""),
                NSLocalizedString("category_living", comment: ""),
                NSLocalizedString("category_clothing", comment: ""),
                NSLocalizedString("category_insurance", comment: ""),
                NSLocalizedString("category_beauty", comment: ""),
                NSLocalizedString("category_health", comment: ""),
                NSLocalizedString("category_education", comment: ""),
                NSLocalizedString("category_communication", comment: ""),
                NSLocalizedString("category_membership", comment: ""),
                NSLocalizedString("category_tax", comment: ""),
                NSLocalizedString("category_event", comment: ""),
                NSLocalizedString("category_savings", comment: ""),
                NSLocalizedString("category_appliances", comment: ""),
                NSLocalizedString("category_utilities", comment: ""),
                NSLocalizedString("category_credit_card", comment: ""),
                NSLocalizedString("category_pet", comment: ""),
                NSLocalizedString("category_travel", comment: ""),
                NSLocalizedString("category_house", comment: ""),
                NSLocalizedString("category_others", comment: "")
            ]
        }
    }

    /*var categoryImageMap: [String: String] {
        switch self {
        case .income:
            return [
                NSLocalizedString("category_salary", comment: ""): "dollarsign.circle.fill",
                NSLocalizedString("category_bonus", comment: ""): "gift.fill",
                NSLocalizedString("category_allowance", comment: ""): "hands.sparkles.fill",
                NSLocalizedString("category_side_job", comment: ""): "briefcase.fill",
                NSLocalizedString("category_investment", comment: ""): "chart.bar.fill",
                NSLocalizedString("category_financial_income", comment: ""): "chart.line.uptrend.xyaxis",
                NSLocalizedString("category_incentive", comment: ""): "gift.circle.fill",
                NSLocalizedString("category_retirement", comment: ""): "figure.walk.arrival",
                NSLocalizedString("category_rental_income", comment: ""): "house.fill",
                NSLocalizedString("category_dividend", comment: ""): "chart.pie.fill",
                NSLocalizedString("category_repayment", comment: ""): "arrow.uturn.left.circle.fill",
                NSLocalizedString("category_inheritance", comment: ""): "person.2.wave.2.fill",
                NSLocalizedString("category_lottery", comment: ""): "trophy.fill",
                NSLocalizedString("category_other_income", comment: ""): "ellipsis.circle.fill"
            ]
        case .expense:
            return [
                NSLocalizedString("category_food", comment: ""): "fork.knife",
                NSLocalizedString("category_transport", comment: ""): "car.fill",
                NSLocalizedString("category_entertainment", comment: ""): "music.note.house.fill",
                NSLocalizedString("category_living", comment: ""): "cart.fill",
                NSLocalizedString("category_clothing", comment: ""): "tshirt.fill",
                NSLocalizedString("category_insurance", comment: ""): "shield.lefthalf.fill",
                NSLocalizedString("category_beauty", comment: ""): "scissors",
                NSLocalizedString("category_health", comment: ""): "cross.case.fill",
                NSLocalizedString("category_education", comment: ""): "book.fill",
                NSLocalizedString("category_communication", comment: ""): "antenna.radiowaves.left.and.right",
                NSLocalizedString("category_membership", comment: ""): "person.3.fill",
                NSLocalizedString("category_tax", comment: ""): "doc.plaintext.fill",
                NSLocalizedString("category_event", comment: ""): "gift.fill",
                NSLocalizedString("category_savings", comment: ""): "banknote.fill",
                NSLocalizedString("category_appliances", comment: ""): "tv.fill",
                NSLocalizedString("category_utilities", comment: ""): "bolt.fill",
                NSLocalizedString("category_credit_card", comment: ""): "creditcard.fill",
                NSLocalizedString("category_pet", comment: ""): "pawprint.fill",
                NSLocalizedString("category_travel", comment: ""): "airplane",
                NSLocalizedString("category_house", comment: ""): "house.fill",
                NSLocalizedString("category_others", comment: ""): "ellipsis.circle.fill"
            ]
        }
    }*/
    
    var categoryImageMap: [String: String] {
        switch self {
        case .income:
            return [
                NSLocalizedString("category_salary", comment: ""): "salary.png",
                NSLocalizedString("category_bonus", comment: ""): "bonus.png",
                NSLocalizedString("category_allowance", comment: ""): "allowance.png",
                NSLocalizedString("category_side_job", comment: ""): "briefcase.png",
                NSLocalizedString("category_investment", comment: ""): "investment.png",
                NSLocalizedString("category_financial_income", comment: ""): "financial_income.png",
                NSLocalizedString("category_incentive", comment: ""): "incentive.png",
                NSLocalizedString("category_retirement", comment: ""): "retirement.png",
                NSLocalizedString("category_rental_income", comment: ""): "house.png",
                NSLocalizedString("category_dividend", comment: ""): "chart_pie.png",
                NSLocalizedString("category_repayment", comment: ""): "arrow.uturn.png",
                NSLocalizedString("category_inheritance", comment: ""): "person_2.png",
                NSLocalizedString("category_lottery", comment: ""): "lottery.png",
                NSLocalizedString("category_other_income", comment: ""): "other_income.png"
            ]
        case .expense:
            return [
                NSLocalizedString("category_food", comment: ""): "fork_knife.png",
                NSLocalizedString("category_transport", comment: ""): "car.png",
                NSLocalizedString("category_entertainment", comment: ""): "music_note.png",
                NSLocalizedString("category_living", comment: ""): "cart_living.png",
                NSLocalizedString("category_clothing", comment: ""): "tshirt.png",
                NSLocalizedString("category_insurance", comment: ""): "insurance.png",
                NSLocalizedString("category_beauty", comment: ""): "beauty.png",
                NSLocalizedString("category_health", comment: ""): "health.png",
                NSLocalizedString("category_education", comment: ""): "book.png",
                NSLocalizedString("category_communication", comment: ""): "antenna.png",
                NSLocalizedString("category_membership", comment: ""): "netflix.png",
                NSLocalizedString("category_tax", comment: ""): "tax.png",
                NSLocalizedString("category_event", comment: ""): "event.png",
                NSLocalizedString("category_savings", comment: ""): "savings.png",
                NSLocalizedString("category_appliances", comment: ""): "tv.png",
                NSLocalizedString("category_utilities", comment: ""): "bolt.png",
                NSLocalizedString("category_credit_card", comment: ""): "creditcard.png",
                NSLocalizedString("category_pet", comment: ""): "pawprint.png",
                NSLocalizedString("category_travel", comment: ""): "airplane.png",
                NSLocalizedString("category_house", comment: ""): "homerent.png",
                NSLocalizedString("category_others", comment: ""): "other_income.png"
            ]
        }
    }
    
    /*var categoryImageMap: [String: String] {
        switch self {
        case .income:
            return [
                NSLocalizedString("category_salary", comment: ""): "💰",
                NSLocalizedString("category_bonus", comment: ""): "🎁",
                NSLocalizedString("category_allowance", comment: ""): "👐",
                NSLocalizedString("category_side_job", comment: ""): "💼",
                NSLocalizedString("category_investment", comment: ""): "📈",
                NSLocalizedString("category_financial_income", comment: ""): "💹",
                NSLocalizedString("category_incentive", comment: ""): "🏆",
                NSLocalizedString("category_retirement", comment: ""): "👴",
                NSLocalizedString("category_rental_income", comment: ""): "🏠",
                NSLocalizedString("category_dividend", comment: ""): "🥧",
                NSLocalizedString("category_repayment", comment: ""): "↩️",
                NSLocalizedString("category_inheritance", comment: ""): "👨‍👩‍👧‍👦",
                NSLocalizedString("category_lottery", comment: ""): "🎲",
                NSLocalizedString("category_other_income", comment: ""): "❓"
            ]
        case .expense:
            return [
                NSLocalizedString("category_food", comment: ""): "🍽",
                NSLocalizedString("category_transport", comment: ""): "🚗",
                NSLocalizedString("category_entertainment", comment: ""): "🎵",
                NSLocalizedString("category_living", comment: ""): "🛒",
                NSLocalizedString("category_clothing", comment: ""): "👕",
                NSLocalizedString("category_insurance", comment: ""): "🛡",
                NSLocalizedString("category_beauty", comment: ""): "💇‍♀️",
                NSLocalizedString("category_health", comment: ""): "🏥",
                NSLocalizedString("category_education", comment: ""): "📚",
                NSLocalizedString("category_communication", comment: ""): "📡",
                NSLocalizedString("category_membership", comment: ""): "📺",
                NSLocalizedString("category_tax", comment: ""): "🧾",
                NSLocalizedString("category_event", comment: ""): "🎉",
                NSLocalizedString("category_savings", comment: ""): "🏦",
                NSLocalizedString("category_appliances", comment: ""): "🖥️",
                NSLocalizedString("category_utilities", comment: ""): "⚡️",
                NSLocalizedString("category_credit_card", comment: ""): "💳",
                NSLocalizedString("category_pet", comment: ""): "🐾",
                NSLocalizedString("category_travel", comment: ""): "✈️",
                NSLocalizedString("category_house", comment: ""): "🏡",
                NSLocalizedString("category_others", comment: ""): "❓"
            ]
        }
    }*/
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
        case .none:
            return NSLocalizedString("repeat_none", comment: "No repeat option")
        case .daily:
            return NSLocalizedString("repeat_daily", comment: "Daily repeat option")
        case .weekly:
            return NSLocalizedString("repeat_weekly", comment: "Weekly repeat option")
        case .monthly:
            return NSLocalizedString("repeat_monthly", comment: "Monthly repeat option")
        case .yearly:
            return NSLocalizedString("repeat_yearly", comment: "Yearly repeat option")
        }
    }
}



// MARK: - Enum 모드 정의
enum AddTransactionMode {
    case create
    case edit(id: UUID)
}
