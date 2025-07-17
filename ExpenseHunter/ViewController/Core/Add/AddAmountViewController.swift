//
//  AddAmountViewController.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/17/25.
//

import UIKit

class AddAmountViewController: UIViewController {
    
    
    // MARK: - Variable
    private var expression: String = "" {
        didSet {
            displayLabel.text = expression
        }
    }
    var onAmountSelected: ((Int) -> Void)?
    
    
    // MARK: - UI Component
    private let displayLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedDigitSystemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.textAlignment = .right
        label.text = "0"
        return label
    }()
    
    private lazy var keypadView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        generateButtons()
    }
    
    
    // MARK: - Function
    private func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(displayLabel)
        view.addSubview(keypadView)
        
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            displayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            displayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            displayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            keypadView.topAnchor.constraint(equalTo: displayLabel.bottomAnchor, constant: 24),
            keypadView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            keypadView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func generateButtons() {
        let rows: [[String]] = [
            ["7", "8", "9", "+"],
            ["4", "5", "6", "-"],
            ["1", "2", "3", "×"],
            ["C", "0", "=", "완료"]
        ]
        
        for row in rows {
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.spacing = 8
            hStack.distribution = .fillEqually
            
            for title in row {
                let button = UIButton(type: .system)
                button.setTitle(title, for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 32, weight: .bold)
                button.backgroundColor = .secondarySystemBackground
                button.layer.cornerRadius = 8
                button.addTarget(self, action: #selector(keyTapped(_:)), for: .touchUpInside)
                hStack.addArrangedSubview(button)
            }
            
            keypadView.addArrangedSubview(hStack)
        }
    }
    
    private func evaluateExpression(_ expr: String) -> String {
        let exp = NSExpression(format: expr)
        if let result = exp.expressionValue(with: nil, context: nil) as? NSNumber {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter.string(from: result) ?? "0"
        }
        return "0"
    }
    
    
    // MARK: - Action Method
    @objc private func keyTapped(_ sender: UIButton) {
        guard let key = sender.title(for: .normal) else { return }
        
        switch key {
        case "C":
            expression = ""
        case "=":
            let exp = expression.replacingOccurrences(of: "×", with: "*")
            let result = evaluateExpression(exp)
            expression = result
        case "완료":
            let clean = expression.replacingOccurrences(of: ",", with: "")
            let number = Int(Double(clean) ?? 0)
            onAmountSelected?(number)
            dismiss(animated: true)
        default:
            expression += key
        }
    }
}
