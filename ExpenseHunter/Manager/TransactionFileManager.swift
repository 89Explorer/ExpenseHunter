//
//  TransactionFileManager.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/18/25.
//

import Foundation
import UIKit



class TransactionFileManager {
    
    // MARK: - Variable
    static let shared = TransactionFileManager()
    private init() { }
    private let fileManager = FileManager.default
    
    
    // MARK: - Function
    // Documents 폴더 경로 가져오기
    private func getDocumentsDirectory() -> URL {
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("❌ Document 디렉토리를 찾을 수 없습니다.")
        }
        return url
    }
    
    
    // 이미지 저장 및 경로 반환하는 메서드
    func saveImage(_ image: UIImage, _ transactionID: String) -> String? {
        let transactionFolder = getDocumentsDirectory().appendingPathComponent(transactionID)
        
        // 기존 폴더 삭제
        if fileManager.fileExists(atPath: transactionFolder.path) {
            try? fileManager.removeItem(at: transactionFolder)
        }
        
        do {
            try fileManager.createDirectory(at: transactionFolder,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
        } catch {
            print("❌ 디렉토리 생성 실패: \(error.localizedDescription)")
        }
        
        let fileName = "image.jpg"
        let fileURL = transactionFolder.appendingPathComponent(fileName)
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            print("❌ 이미지 데이터를 JPEG로 변환 실패")
            return nil
        }
        
        do {
            try imageData.write(to: fileURL)
            return "\(transactionID)/\(fileName)"
        } catch {
            print("❌ 이미지 저장 실패: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    // 저장한 이미지를 불러오는 함수
    func loadImage(from relativePath: String) -> UIImage? {
        let fullPath = getDocumentsDirectory().appendingPathComponent(relativePath)
        if !fileManager.fileExists(atPath: fullPath.path) {
            print("❌ 이미지 경로 없음: \(fullPath.path)")
            return nil
        }
        return UIImage(contentsOfFile: fullPath.path)
    }
    
    
    // 이미지 삭제하는 함수
    func deleteFolder(for transactionID: String) -> Bool {
        let folder = getDocumentsDirectory().appendingPathComponent(transactionID)
        if fileManager.fileExists(atPath: folder.path) {
            do {
                try fileManager.removeItem(at: folder)
                return true
            } catch {
                print("❌ 폴더 삭제 실패: \(error.localizedDescription)")
                return false
            }
        }
        return false
    }
}
