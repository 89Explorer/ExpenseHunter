//
//  ExpenseEntity+CoreDataProperties.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/19/25.
//
//

import Foundation
import CoreData
import UIKit


extension ExpenseEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseEntity> {
        return NSFetchRequest<ExpenseEntity>(entityName: "ExpenseEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var transaction: String?
    @NSManaged public var amount: Int64
    @NSManaged public var date: Date?
    @NSManaged public var imagePath: String?
    @NSManaged public var category: String?
    @NSManaged public var memo: String?
    @NSManaged public var isRepeated: Bool
    @NSManaged public var repeatCycle: String? 

}

extension ExpenseEntity : Identifiable {

}


extension ExpenseEntity {
    func toModel() -> ExpenseModel? {
        guard
            let idString = self.id,
            let uuid = UUID(uuidString: idString),
            let transactionRaw = self.transaction,
            let transaction = TransactionType(rawValue: transactionRaw),
            let category = self.category,
            let date = self.date,
            let memo = self.memo
        else {
            print("❌ toModel 변환 실패: 필수 값 누락")
            return nil
        }

        let image: UIImage?
        if let path = self.imagePath, !path.isEmpty {
            image = TransactionFileManager.shared.loadImage(from: path)
        } else {
            image = nil
        }
        
        let isRepeatedValue = self.isRepeated
        let repeatCycleEnum = RepeatCycle(rawValue: self.repeatCycle ?? "") ?? .none

        return ExpenseModel(
            id: uuid,
            transaction: transaction,
            category: category,
            amount: Int(self.amount),
            image: image,
            date: date,
            memo: memo,
            isRepeated: isRepeatedValue,    // 반복기능
            repeatCycle: repeatCycleEnum    // 반복단위
        )
    }
}
