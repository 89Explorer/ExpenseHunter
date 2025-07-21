//
//  TransactionCoreDataManager.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/19/25.
//

import Foundation
import CoreData
import UIKit
import Combine


final class TransactionCoreDataManager {
    
    
    // MARK: - Variable
    static let shared = TransactionCoreDataManager()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let storageManager = TransactionFileManager.shared
    
    
    // MARK: - Function
    // Create
    func createTransaction(_ transaction: ExpenseModel) -> AnyPublisher<ExpenseModel, Error> {
        return Future { [weak self] promise in
            guard let self = self
            else { return }
            
            //            guard let savePath = self.storageManager.saveImage(selectedimage, transaction.id.uuidString) else {
            //                print("❌ 이미지 저장 실패")
            //                promise(.failure(NSError(domain: "TransactionImageSaveError", code: 1)))
            //                return
            //            }
            
            var savePath: String? = nil
            if let selectedImage = transaction.image {
                savePath = self.storageManager.saveImage(selectedImage, transaction.id.uuidString)
                
                if savePath == nil {
                    print("❌ 이미지 저장 실패")
                    promise(.failure(NSError(domain: "TransactionImageSaveError", code: 1)))
                    return
                }
            }
            
            // ✅ 디버깅 로그 시작
            print("🧾 CoreDataManager: 저장할 Expense 정보 확인")
            print("   - ID: \(transaction.id)")
            print("   - 금액: \(transaction.amount)")
            print("   - 날짜: \(transaction.date)")
            print("   - 카테고리: \(transaction.category)")
            print("   - 타입: \(transaction.transaction.rawValue)")
            print("   - 메모: \(transaction.memo ?? "없음")")
            print("   - 이미지 경로: \(savePath)")
            
            let expenseEntity = ExpenseEntity(context: self.context)
            expenseEntity.id = transaction.id.uuidString
            expenseEntity.amount = Int64(transaction.amount)
            expenseEntity.date = transaction.date
            expenseEntity.category = transaction.category
            expenseEntity.transaction = transaction.transaction.rawValue
            expenseEntity.memo = transaction.memo 
            expenseEntity.imagePath = savePath ?? ""
            
            do {
                try self.context.save()
                if let model = expenseEntity.toModel() {
                    print("✅ Core Data 저장 + 변환 성공!")
                    promise(.success(model))
                } else {
                    print("❌ Entity → Model 변환 실패")
                    promise(.failure(NSError(domain: "ModelConversionError", code: 2)))
                }
            } catch {
                print("❌ Core Data 저장 실패: \(error.localizedDescription)")
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    // Read All
    func readAllTransaction() -> AnyPublisher<[ExpenseModel], Error> {
        return Future { [weak self] promise in
            guard let self = self else {
                print("❌ TransactionManager: self가 nil이므로 종료")
                return
            }
            
            let fetchRequest: NSFetchRequest<ExpenseEntity> = ExpenseEntity.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            
            do {
                let expenseEntities = try self.context.fetch(fetchRequest)
                print("✅ TransactionManager: Read 성공, 총 \(expenseEntities.count)개의 데이터 읽기 성공!")
                
                let transactions: [ExpenseModel] = expenseEntities.compactMap { $0.toModel() }
                
                promise(.success(transactions))
                print("✅ TransactionManager: 최종 읽어온 데이터 \(transactions.count)개")
                
            } catch {
                print("❌ TransactionManager: Core Data 불러오기 실패 \(error.localizedDescription)")
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    // Read by ID
    func readTransactionByID(by id: UUID) -> AnyPublisher<ExpenseModel?, Error> {
        return Future { [weak self] promise in
            guard let self = self else {
                print("❌ TransactionManager: self가 nil이므로 종료")
                return
            }
            
            let fetchRequest: NSFetchRequest<ExpenseEntity> = ExpenseEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
            fetchRequest.fetchLimit = 1
            
            do {
                let result = try self.context.fetch(fetchRequest)
                let model = result.first?.toModel()
                if model == nil {
                    print("⚠️ 해당 ID로 찾은 데이터가 없어요")
                } else {
                    print("✅ TransactionManager: \(id) 읽기 성공")
                }
                promise(.success(model))
            } catch {
                print("❌ TransactionManager: ID로 불러오기 실패 \(error.localizedDescription)")
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    // Update
//    func updateTransaction(_ updatedTransaction: ExpenseModel, image: UIImage?) -> AnyPublisher<ExpenseModel, Error> {
//        return Future { [weak self] promise in
//            guard let self = self else {
//                print("❌ TransactionManager: self가 nil")
//                return
//            }
//            
//            let fetchRequest: NSFetchRequest<ExpenseEntity> = ExpenseEntity.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "id == %@", updatedTransaction.id.uuidString)
//            fetchRequest.fetchLimit = 1
//            
//            do {
//                guard let entity = try self.context.fetch(fetchRequest).first else {
//                    print("❌ 업데이트할 항목 없음")
//                    promise(.failure(NSError(domain: "TransactionUpdateError", code: 404)))
//                    return
//                }
//                
//                entity.transaction = updatedTransaction.transaction.rawValue
//                entity.amount = Int64(updatedTransaction.amount)
//                entity.date = updatedTransaction.date
//                entity.category = updatedTransaction.category
//                entity.memo = updatedTransaction.memo
//                
//                if let newImage = image {
//                    if let oldPath = entity.imagePath {
//                        let deleted = self.storageManager.deleteFolder(for: oldPath)
//                        if !deleted {
//                            print("⚠️ 기존 이미지 삭제 실패: \(oldPath)")
//                            promise(.failure(NSError(domain: "ImageDeleteFailed", code: 501)))
//                            return
//                        }
//                        
//                    }
//                    if let newPath = self.storageManager.saveImage(newImage, updatedTransaction.id.uuidString) {
//                        entity.imagePath = newPath
//                    } else {
//                        print("❌ 새 이미지 저장 실패")
//                        promise(.failure(NSError(domain: "ImageSaveFailed", code: 500)))
//                        return
//                    }
//                }
//                
//                try self.context.save()
//                print("✅ 업데이트 성공!")
//                promise(.success(updatedTransaction))
//            } catch {
//                print("❌ Core Data 업데이트 실패: \(error.localizedDescription)")
//                promise(.failure(error))
//            }
//        }
//        .eraseToAnyPublisher()
//    }
    
    func updateTransaction(_ updatedTransaction: ExpenseModel) -> AnyPublisher<ExpenseModel, Error> {
        return Future { [weak self] promise in
            guard let self = self else {
                print("❌ TransactionManager: self가 nil")
                return
            }

            let fetchRequest: NSFetchRequest<ExpenseEntity> = ExpenseEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", updatedTransaction.id.uuidString)
            fetchRequest.fetchLimit = 1

            do {
                guard let entity = try self.context.fetch(fetchRequest).first else {
                    print("❌ 업데이트할 항목 없음")
                    promise(.failure(NSError(domain: "TransactionUpdateError", code: 404)))
                    return
                }

                entity.transaction = updatedTransaction.transaction.rawValue
                entity.amount = Int64(updatedTransaction.amount)
                entity.date = updatedTransaction.date
                entity.category = updatedTransaction.category
                entity.memo = updatedTransaction.memo

//                if let newImage = updatedTransaction.image {
//                    // 새 이미지가 있을 경우 기존 이미지 제거 후 새 이미지 저장
//                    if let oldPath = entity.imagePath {
//                        let deleted = self.storageManager.deleteFolder(for: oldPath)
//                        if !deleted {
//                            print("⚠️ 기존 이미지 삭제 실패: \(oldPath)")
//                            promise(.failure(NSError(domain: "ImageDeleteFailed", code: 501)))
//                            return
//                        }
//                    }
//
//                    if let newPath = self.storageManager.saveImage(newImage, updatedTransaction.id.uuidString) {
//                        entity.imagePath = newPath
//                    } else {
//                        print("❌ 새 이미지 저장 실패")
//                        promise(.failure(NSError(domain: "ImageSaveFailed", code: 500)))
//                        return
//                    }
//                } else {
//                    // 새 이미지가 없을 경우 (= 변경하지 않음)
//                    // 👉 아무 작업도 하지 않음 (기존 이미지 그대로 유지)
//                    print("ℹ️ 이미지 변경 없음")
//                }

//                if let newImage = updatedTransaction.image {
//                    if let oldPath = entity.imagePath, !oldPath.isEmpty {
//                        // 기존 이미지 경로가 존재하면 삭제 시도
//                        let deleted = self.storageManager.deleteFolder(for: oldPath)
//                        if !deleted {
//                            print("⚠️ 기존 이미지 삭제 실패: \(oldPath)")
//                            // 삭제 실패하더라도, 이미지 저장은 시도할 수 있음
//                            // 실패를 무시하고 계속 진행하려면 주석 처리:
//                            // promise(.failure(NSError(domain: "ImageDeleteFailed", code: 501)))
//                            // return
//                        }
//                    }
//
//                    // 새 이미지 저장
//                    if let newPath = self.storageManager.saveImage(newImage, updatedTransaction.id.uuidString) {
//                        entity.imagePath = newPath
//                    } else {
//                        print("❌ 새 이미지 저장 실패")
//                        promise(.failure(NSError(domain: "ImageSaveFailed", code: 500)))
//                        return
//                    }
//                } else {
//                    // 새 이미지가 없을 경우 = 기존 이미지 유지
//                    print("ℹ️ 이미지 변경 없음")
//                }
                
                if let newImage = updatedTransaction.image {
                    // 기존 이미지 제거
                    if let oldPath = entity.imagePath, !oldPath.isEmpty {
                        let deleted = self.storageManager.deleteFolder(for: oldPath)
                        if !deleted {
                            print("⚠️ 기존 이미지 삭제 실패: \(oldPath)")
                            // 삭제 실패 무시할지 여부는 정책에 따라
                        }
                    }

                    // 새 이미지 저장
                    if let newPath = self.storageManager.saveImage(newImage, updatedTransaction.id.uuidString) {
                        entity.imagePath = newPath
                    } else {
                        print("❌ 새 이미지 저장 실패")
                        promise(.failure(NSError(domain: "ImageSaveFailed", code: 500)))
                        return
                    }

                } else {
                    // 새 이미지 없음 → 기존 이미지도 삭제 대상일 수 있음
                    if let oldPath = entity.imagePath, !oldPath.isEmpty {
                        let deleted = self.storageManager.deleteFolder(for: oldPath)
                        if deleted {
                            entity.imagePath = nil  // 경로도 지워야 함
                            print("🗑️ 기존 이미지 삭제 완료")
                        } else {
                            print("⚠️ 기존 이미지 삭제 실패 (삭제만 시도했음)")
                            // 필요시 실패 처리 가능
                        }
                    } else {
                        print("ℹ️ 삭제할 기존 이미지 없음")
                    }
                }

                
                try self.context.save()
                print("✅ 업데이트 성공!")
                promise(.success(updatedTransaction))

            } catch {
                print("❌ Core Data 업데이트 실패: \(error.localizedDescription)")
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    
    // Delete
    func deleteTransaction(id: UUID) -> AnyPublisher<Bool, Error> {
        return Future { [weak self] promise in
            guard let self = self else {
                print("❌ deleteTransaction: self가 nil입니다.")
                return
            }
            
            let fetchRequest: NSFetchRequest<ExpenseEntity> = ExpenseEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
            
            do {
                let result = try self.context.fetch(fetchRequest)
                guard let entityToDelete = result.first else {
                    print("❌ deleteTransaction: 해당 ID에 해당하는 항목을 찾을 수 없음")
                    promise(.failure(NSError(domain: "TransactionNotFound", code: 404)))
                    return
                }
                
                // 이미지 경로가 있는 경우 파일도 삭제
                if let imagePath = entityToDelete.imagePath {
                    let imageDeleted = self.storageManager.deleteFolder(for: imagePath)
                    if imageDeleted {
                        print("🗑️ 이미지 삭제 성공")
                    } else {
                        print("⚠️ 이미지 삭제 실패 (파일이 없을 수도 있음)")
                    }
                }
                
                self.context.delete(entityToDelete)
                
                try self.context.save()
                print("✅ deleteTransaction: Core Data 삭제 성공")
                promise(.success(true))
            } catch {
                print("❌ deleteTransaction: 삭제 중 오류 발생 - \(error.localizedDescription)")
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
}
