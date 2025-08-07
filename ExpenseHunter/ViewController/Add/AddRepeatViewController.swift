//
//  AddRepeatViewController.swift
//  ExpenseHunter
//
//  Created by 권정근 on 8/7/25.
//

import UIKit

final class AddRepeatViewController: UIViewController {
    
    
    // MARK: -  Variable
    var onRepeatSelected: ((RepeatCycle) -> Void)?
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        showRepeatOptions()
    }
    
    
    // MARK: - Function
    private func showRepeatOptions() {
        let alert = UIAlertController(title: "반복 주기 선택", message: nil, preferredStyle: .actionSheet)
        
        RepeatCycle.allCases.forEach { cycle in
            let action = UIAlertAction(title: cycle.title, style: .default) { [weak self] _ in
                self?.onRepeatSelected?(cycle)
                self?.dismiss(animated: true)
            }
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
}
