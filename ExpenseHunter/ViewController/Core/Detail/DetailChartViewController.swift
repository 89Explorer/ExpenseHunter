//
//  DetailChartViewController.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/22/25.
//

import UIKit

class DetailChartViewController: UIViewController {

    
    // MARK: - Variable
    
    
    // MARK: - UI Component
    private let chartTableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        
    }
    
    
    // MARK: - Function
    private func configure() {
        chartTableView.showsVerticalScrollIndicator = false
        chartTableView.backgroundColor = .clear
        
        chartTableView.rowHeight = UITableView.automaticDimension
        chartTableView.estimatedRowHeight = 150
        
        view.addSubview(chartTableView)
        chartTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
        ])
    }
}
