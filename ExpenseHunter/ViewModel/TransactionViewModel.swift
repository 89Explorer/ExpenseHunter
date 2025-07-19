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
    
    
    // MARK: - Variable
    @Published var transaction: ExpenseModel?
    @Published var transactions: [ExpenseModel] = []
    @Published var errorMessage: String?
    
    var currentCategories: [String] {
        transaction?.transaction.categoryOptions ?? []
    }
    
    var currentCategoryIcons: [String: String] {
        transaction?.transaction.categoryImageMap ?? [:]
    }
    
    private var cancellables: Set<AnyCancellable> = []
    private let transactionManager = TransactionCoreDataManager.shared
    
    
    // MARK: - Init
    init(transaction: ExpenseModel? = nil) {
        if let transaction = transaction {
            self.transaction = transaction  // 수정 모드 (기존 모델)
        } else {
            self.transaction = ExpenseModel( // 새로 생성
                id: UUID(),
                transaction: .expense,
                category: "",
                amount: 0,
                image: nil,
                date: Date(),
                memo: ""
            )
        }
    }
    
    
    // MARK: - Function
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

}
