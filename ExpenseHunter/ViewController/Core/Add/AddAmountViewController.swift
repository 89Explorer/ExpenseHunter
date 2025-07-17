//
//  AddAmountViewController.swift
//  ExpenseHunter
//
//  Created by 권정근 on 7/17/25.
//


import UIKit

final class AddAmountViewController: UIViewController {
    
    // MARK: - Variable
    // 계산한 값을 전달할 클로저
    var onAmountSelected: ((Int) -> Void)?
    private var rawExpression: String = "" {
        didSet {
            updateDisplay()
        }
    }
    
    
    // MARK: - UI Component
    private let displayLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedDigitSystemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.textAlignment = .right
        label.text = "₩ 0 원"
        label.numberOfLines = 1
        return label
    }()
    
    private let keypadRows: [[String]] = [
        ["(", ")", "⌫", "C"],
        ["7", "8", "9", "÷"],
        ["4", "5", "6", "×"],
        ["1", "2", "3", "−"],
        ["0", ".", "=", "+"],
        ["완료"]
    ]
    
    private lazy var keypadStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupUI()
        generateButtons()
    }
    
    private func setupUI() {
        view.addSubview(displayLabel)
        view.addSubview(keypadStack)
        
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            displayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            displayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            displayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            keypadStack.topAnchor.constraint(equalTo: displayLabel.bottomAnchor, constant: 24),
            keypadStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            keypadStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func generateButtons() {
        for row in keypadRows {
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.spacing = 8
            hStack.distribution = .fillEqually
            
            for key in row {
                let button = UIButton(type: .system)
                button.setTitle(key, for: .normal)
                button.setTitleColor(.label, for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
                button.layer.cornerRadius = 8
                button.backgroundColor = .secondarySystemFill
                button.heightAnchor.constraint(equalToConstant: 48).isActive = true
                button.addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
                hStack.addArrangedSubview(button)
            }
            
            keypadStack.addArrangedSubview(hStack)
        }
    }
    
    private func updateDisplay() {
        let formatted = formatExpression(rawExpression)
        displayLabel.text = formatted
    }
    
    private func formatExpression(_ input: String) -> String {
        let sanitized = input
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
            .replacingOccurrences(of: "−", with: "-")
        
        // 계산 결과라면 format
        if let result = Double(sanitized),
           !input.contains("+") && !input.contains("-") &&
            !input.contains("*") && !input.contains("/") {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let numberText = formatter.string(from: NSNumber(value: result)) ?? "0"
            return "₩ \(numberText) 원"
        }
        
        return input
    }
    
    func evaluateExpression(from rawExpression: String) -> Double {
        let sanitized = rawExpression
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "x", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
            .replacingOccurrences(of: "−", with: "-")
            .replacingOccurrences(of: "₩", with: "")      // 화폐 기호 제거
            .replacingOccurrences(of: ",", with: "")       // 쉼표 제거
            .replacingOccurrences(of: "원", with: "")      // 단위 제거
            .replacingOccurrences(of: " ", with: "")       // 공백 제거

        // 괄호 쌍이 맞는지 확인
        let openCount = sanitized.filter { $0 == "(" }.count
        let closeCount = sanitized.filter { $0 == ")" }.count
        guard openCount == closeCount else {
            print("❌ 괄호 쌍 불일치")
            return 0
        }

        let expression = NSExpression(format: sanitized)
        if let result = expression.expressionValue(with: nil, context: nil) as? NSNumber {
            return result.doubleValue
        } else {
            print("❌ 수식 계산 실패: \(sanitized)")
            return 0
        }
    }

    
    private func evaluateExpression() -> String {
        let sanitized = rawExpression
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
            .replacingOccurrences(of: "−", with: "-")
            .trimmingCharacters(in: .whitespaces)
        
        // ✅ 유효한 수식인지 확인
        guard !sanitized.isEmpty,
              let firstChar = sanitized.first,
              ("0"..."9").contains(String(firstChar)) else {
            return "0"
        }
        
        // ✅ 수식 계산 시도
        let expression = NSExpression(format: sanitized)
        if let value = expression.expressionValue(with: nil, context: nil) as? NSNumber {
            return String(format: "%.0f", value.doubleValue)
        }
        
        return "0"
    }
    
    
    // MARK: - Action Method
    @objc private func keyPressed(_ sender: UIButton) {
        guard let key = sender.title(for: .normal) else { return }

        switch key {
        case "C":
            rawExpression = ""

        case "⌫":
            if !rawExpression.isEmpty {
                rawExpression.removeLast()
            }

        case "=":
            let result = evaluateExpression(from: rawExpression)
            rawExpression = result == 0 ? "" : String(result)

        case "완료":
            let result = evaluateExpression(from: rawExpression)
            onAmountSelected?(Int(result))
            dismiss(animated: true)

        default:
            rawExpression += key
        }

        updateDisplay()
    }

}
